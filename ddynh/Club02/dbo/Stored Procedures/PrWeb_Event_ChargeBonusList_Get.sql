-- =============================================
-- Author:  MARS
-- Create date: 2019/08/12
-- Description: 充值返利活動  取得個人流水及限制
--    2019/08/12	mars	增加@intEventID來決定要走哪個活動, default為1:充值返利
--    2019/08/12	mars	增加存款返利下限
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Event_ChargeBonusList_Get]	
(
	@intUserID	INT,
	@intEventID INT = 0,  --event
	@lngNowFlowAmount BIGINT OUTPUT,
	@lngFlowAmountLimit BIGINT OUTPUT,
	@lngDepositAmountLimit BIGINT OUTPUT,
	@intRate FLOAT OUTPUT,
	@lngFlowAmountMultiple BIGINT OUTPUT,
	@intEventStatus INT OUTPUT,
	@chvMsg VARCHAR(100) OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @NowTime DATETIME = GETDATE()
	DECLARE @EventID INT = 1
	DECLARE @EventStatus INT = 0
	DECLARE @PlatformID INT
	DECLARE @AreaID INT
	DECLARE @NowFlowAmount BIGINT
	DECLARE @FlowAmountLimit BIGINT
	DECLARE @DepositAmountLimit BIGINT
	DECLARE @Rate FLOAT
	DECLARE @FlowAmountMultiple BIGINT
	
	IF (@intEventID > 0)
		SET @EventID = @intEventID;

	SELECT	@NowFlowAmount = SumFlowAmount,
			@AreaID = AreaID
	FROM CenterDB.Users.UserInfo WITH (NOLOCK)
	WHERE
		UserID = @intUserID

	SELECT	@PlatformID = PlatformID
	FROM CenterDB.Area.Area WITH (NOLOCK)
	WHERE
		AreaID = @AreaID

	SELECT	@Rate = ([LngValue1] * 1.00 / 10000),
			@FlowAmountMultiple = [LngValue2],
			@DepositAmountLimit = [LngValue3]
	FROM [dbo].[EventContent] WITH (NOLOCK)
	WHERE
		[PlatformID] = @PlatformID
		AND AreaID = @AreaID
		AND EventID = @EventID	

	SELECT	@FlowAmountLimit = [ChargeAmount] * @FlowAmountMultiple
	FROM Club02.dbo.Event_ChargeBonusRecord WITH (NOLOCK)
	WHERE
		[UserID] = @intUserID

	SELECT	@EventStatus = CASE WHEN [EventStartDate] <= @NowTime AND [EventEndDate] > @NowTime AND [Status] = 1 THEN 1 ELSE 0 END
	FROM [dbo].[EventPlatformInfo] WITH (NOLOCK)
	WHERE
		[PlatformID] = @PlatformID
		AND AreaID = @AreaID
		AND EventID = @EventID

	SET @lngNowFlowAmount = ISNULL(@NowFlowAmount,0)
	SET @lngFlowAmountLimit = ISNULL(@FlowAmountLimit,0)
	SET @lngDepositAmountLimit = ISNULL(@DepositAmountLimit,0)
	SET @intRate = ROUND(ISNULL(@Rate,0),2)
	SET @lngFlowAmountMultiple = ISNULL(@FlowAmountMultiple,0)
	SET @intEventStatus = ISNULL(@EventStatus,0)

	SET @chvMsg = '操作完成'
	RETURN 1
END