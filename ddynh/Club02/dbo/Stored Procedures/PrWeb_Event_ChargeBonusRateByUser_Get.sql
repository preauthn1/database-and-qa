-- =============================================
-- Author:  jason
-- Create date: 2019/05/30
-- Description: 充值返利活動  取得返利內容(CenterDB呼叫)
--  2019/07/30	mars		增加@intEventID, 來取得對應的事件
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Event_ChargeBonusRateByUser_Get]	
(
	@intUserID	INT,
	@intEventID INT = 0,
	@Rate		FLOAT	OUTPUT,
	@chvMsg		VARCHAR(100) OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @EventID INT = 1
	DECLARE @PlatformID INT
	DECLARE @AreaID INT
	DECLARE @NowTime DATETIME = GETDATE()
	DECLARE @Status INT = 1

	IF (@intEventID > 0)
		SET @EventID = @intEventID

	SELECT	@AreaID = AreaID
	FROM CenterDB.Users.UserInfo WITH (NOLOCK)
	WHERE
		UserID = @intUserID

	SELECT	@PlatformID = PlatformID
	FROM CenterDB.Area.Area WITH (NOLOCK)
	WHERE
		AreaID = @AreaID


	SELECT	@Rate = ([LngValue1] * 1.00 / 10000)
	FROM [dbo].[EventPlatformInfo] AS A WITH (NOLOCK)
		INNER JOIN [dbo].[EventContent] AS B WITH (NOLOCK) ON A.PlatformID = B.PlatformID AND A.AreaID = B.AreaID AND B.EventID = @EventID
	WHERE
		A.PlatformID = @PlatformID
		AND A.AreaID = @AreaID
		AND A.EventStartDate <= @NowTime
		AND A.EventEndDate > @NowTime
		AND [Status] = @Status
		AND A.EventID = @EventID

	SET @Rate = ROUND(ISNULL(@Rate,0),2)
	

	SET @chvMsg = '操作完成'
	RETURN 1
END
