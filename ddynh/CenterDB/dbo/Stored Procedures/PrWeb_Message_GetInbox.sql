-- =============================================
-- Author:  Mars
-- Create date: 2019/09/10
-- Description:	收件箱查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Message_GetInbox]
(
	@intAdminID INT,
	@intPlatformID INT = NULL,
	@intFromUserID INT = NULL,
	@intToUserID INT = NULL,
	@intMsgID INT = NULL,
	@intType INT = NULL,
	@intStatus INT = NULL,
	@dtSendTimeBegin DATETIME = NULL,
	@dtSendTimeEnd DATETIME = NULL,
	@dtReadTimeBegin DATETIME = NULL,
	@dtReadTimeEnd DATETIME = NULL,
	@intPageIndex INT = 1,
	@intPageSize INT = 20,
	@intPageCount VARCHAR(32) OUTPUT
)
AS
BEGIN

	--渠道篩選
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	INSERT INTO @Temp_PlatformID Select PlatformID From CenterDB.Area.PlatformAdminUser where AdminID = @intAdminID
	
	SELECT @intPageCount = COUNT(1) 
	FROM Message.ReceiveUser AS R with(nolock)
	JOIN Message.MessageList AS L ON R.MsgID = L.MsgID 
	JOIN Users.UserInfo AS U ON U.Userid = R.UserID 
	JOIN Area.area AS A ON A.AreaID = U.AreaID
	JOIN Area.Platform AS P ON P.PlatformID = A.PlatformID
	WHERE A.PlatformID in (select PlatformID from @Temp_PlatformID)
		AND (@intPlatformID IS NULL OR A.PlatformID = @intPlatformID)
		AND (@intMsgID IS NULL OR R.MsgID = @intMsgID) 
		AND (@intType IS NULL OR L.Type = @intType) 
		AND (@intStatus IS NULL OR R.Status = @intStatus) 
		AND (@dtReadTimeBegin IS NULL OR R.ReadTime >= @dtReadTimeBegin) 
		AND (@dtReadTimeEnd IS NULL OR R.ReadTime <= @dtReadTimeEnd) 
		AND (@dtSendTimeBegin IS NULL OR L.CreateTime >= @dtSendTimeBegin) 
		AND (@dtSendTimeEnd IS NULL OR L.CreateTime <= @dtSendTimeEnd) 
		AND (@intFromUserID IS NULL OR L.FromUserID = @intFromUserID) 
		AND (@intToUserID IS NULL OR R.UserID = @intToUserID)
	;WITH tab AS 
	(
		SELECT rowid = ROW_NUMBER() over(order by L.CreateTime desc),
			R.ReadTime,
			P.Name as Platform, 
			U.UserID, 
			U.LoginName,
			U.GradeID,
			L.MsgID,
			L.MsgContent,
			R.Status
		FROM Message.ReceiveUser AS R with(nolock)
		JOIN Message.MessageList AS L ON R.MsgID = L.MsgID 
		JOIN Users.UserInfo AS U ON U.Userid = R.UserID 
		JOIN Area.area AS A ON A.AreaID = U.AreaID
		JOIN Area.Platform AS P ON P.PlatformID = A.PlatformID
		WHERE A.PlatformID in (select PlatformID from @Temp_PlatformID)
			AND (@intPlatformID IS NULL OR A.PlatformID = @intPlatformID)
			AND (@intMsgID IS NULL OR R.MsgID = @intMsgID) 
			AND (@intType IS NULL OR L.Type = @intType) 
			AND (@intStatus IS NULL OR R.Status = @intStatus) 
			AND (@dtReadTimeBegin IS NULL OR R.ReadTime >= @dtReadTimeBegin) 
			AND (@dtReadTimeEnd IS NULL OR R.ReadTime <= @dtReadTimeEnd) 
			AND (@dtSendTimeBegin IS NULL OR L.CreateTime >= @dtSendTimeBegin) 
			AND (@dtSendTimeEnd IS NULL OR L.CreateTime <= @dtSendTimeEnd) 
			AND (@intFromUserID IS NULL OR L.FromUserID = @intFromUserID) 
			AND (@intToUserID IS NULL OR R.UserID = @intToUserID) 	
	)
	--ORDER BY L.CreateTime DESC	

SELECT * FROM tab WHERE rowid between @intPageSize * (@intPageIndex -1) + 1 and @intPageSize * @intPageIndex
	
END