-- =============================================
-- Author:  jason
-- Create date: 2019/05/28
-- Description: 活動 充值返利活動SP
--   2019/07/30		mars 增加@intEventID來決定要走哪個活動, default為1:充值返利
-- 							取得活動倍率及計算最低流水 SQL 增加AND C.PlatformID = @PlatformID AND C.AreaID = @AreaID AND C.EventID = @EventID
-- 							取消@lngChargeAmount * 100
--	 2019/08/12		mars	增加FlowCalcType, 改變流水計算方式 0: ChargeAmoun * FlowAmount, 1: (ChargeAmount+Bonus) * FlowAmount
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Event_ChargeBonusEvent]	
(
	@intUserID			INT,
	@lngChargeAmount	BIGINT,  --分為單位
	@intEventID			INT = 0,  --event
	@chvMsg		VARCHAR(100) OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @NowTime			DATETIME = GETDATE()
	DECLARE @PlatformID			INT
	DECLARE @AreaID				INT
	DECLARE @Rate				INT
	DECLARE @FlowCalcType		INT = 0
	DECLARE @FlowAmountRate		BIGINT
	DECLARE @FlowAmountLimit	BIGINT
	DECLARE @SumFlowAmount		BIGINT
	DECLARE @ChargeAmount		BIGINT
	DECLARE @EventID			INT = 1		-- 活動編號 依照後台已新增後才建立判斷SP
	DECLARE @Status				INT = 1		-- 0:活動關閉 1:活動開啟

	IF (@intEventID > 0)
		SET @EventID = @intEventID;

	/*  取用戶現有資訊  */
	SELECT	@SumFlowAmount = SumFlowAmount,
			@AreaID = AreaID
	FROM CenterDB.Users.UserInfo WITH (NOLOCK)
	WHERE
		UserID = @intUserID

	SELECT	@PlatformID = PlatformID
	FROM CenterDB.Area.Area WITH (NOLOCK)
	WHERE
		AreaID = @AreaID


	IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[EventPlatformInfo] WITH (NOLOCK) WHERE PlatformID = @PlatformID AND AreaID = @AreaID AND [Status] = @Status AND EventID = @EventID)
	BEGIN
		SET @chvMsg = '無充值返利活動'
		RETURN 1
	END

	/*  取用戶活動紀錄  */
	IF EXISTS (SELECT TOP 1 1 FROM [dbo].[Event_ChargeBonusRecord] WITH (NOLOCK) WHERE UserID = @intUserID)
	BEGIN
		SELECT	@ChargeAmount = (@lngChargeAmount ) + [ChargeAmount]
		FROM [dbo].[Event_ChargeBonusRecord] WITH (NOLOCK)
			WHERE UserID = @intUserID
	END
	ELSE
	BEGIN
		SET @ChargeAmount = @lngChargeAmount 
	END

	/*  取得活動倍率及計算最低流水  */
	--0.10	3	1
	SELECT TOP 1 @Rate = ([LngValue1] / 100),		--Rate
					@FlowAmountRate = [LngValue2],  --流水倍數
					@FlowCalcType = [LngValue4]		--流水計算方式
	FROM [dbo].[EventInfo] AS A WITH (NOLOCK)
		INNER JOIN [dbo].[EventPlatformInfo] AS B WITH (NOLOCK)
			ON A.EventID = B.EventID AND B.PlatformID = @PlatformID AND B.AreaID = @AreaID
				AND B.EventStartDate <= @NowTime AND B.EventEndDate > @NowTime AND [Status] = @Status
		INNER JOIN [dbo].[EventContent] AS C WITH (NOLOCK) ON B.EventID = C.EventID 
		AND C.PlatformID = @PlatformID AND C.AreaID = @AreaID AND C.EventID = @EventID 

	IF (@FlowCalcType = 1)
		SET @FlowAmountLimit = ISNULL(@SumFlowAmount,0) + ((@ChargeAmount + (@ChargeAmount * @Rate)) * @FlowAmountRate)
	ELSE
		SET @FlowAmountLimit = ISNULL(@SumFlowAmount,0) + (@ChargeAmount * @FlowAmountRate)

	/*  寫入活動資料  */
	IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[Event_ChargeBonusRecord] WITH (NOLOCK) WHERE UserID = @intUserID)
	BEGIN
		INSERT INTO [dbo].[Event_ChargeBonusRecord]
			([UserID],[ChargeDate],[ChargeAmount],[SumFlowAmount],[FlowAmountLimit])
		VALUES
			(@intUserID,@NowTime,@ChargeAmount,@SumFlowAmount,@FlowAmountLimit)
	END

	ELSE
	BEGIN
		UPDATE [dbo].[Event_ChargeBonusRecord]
		SET [ChargeDate] = @NowTime,
			[ChargeAmount] = @ChargeAmount,
			[FlowAmountLimit] = @FlowAmountLimit
		WHERE
			UserID = @intUserID 
	END

	IF @@ROWCOUNT <> 1
	BEGIN
		SET @chvMsg = '操作失敗 : 返利活動資格有誤,請聯繫客服'
		RETURN -1
	END


	SET @chvMsg = '操作完成'
	RETURN 1
END
