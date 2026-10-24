-- =============================================
-- Author:  Mars
-- Create date: 2019/09/09
-- Description:	取得消息列表
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Message_GetList]
(
	@intAdminID INT,
	@chvTitle VARCHAR(100) = NULL,
	@intType INT = NULL,
	@intPlatformID INT = NULL,
	@dtCreatTime DATETIME = NULL,
	@intPageIndex INT = 1,
	@intPageSize INT = 20,
	@intPageCount VARCHAR(32) OUTPUT
)
AS
BEGIN

	--渠道篩選
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	INSERT INTO @Temp_PlatformID Select PlatformID From CenterDB.Area.PlatformAdminUser where AdminID = @intAdminID
	
	IF (@chvTitle IS NOT NULL)
		SET @chvTitle = '%' + @chvTitle + '%'
	
	SELECT @intPageCount = COUNT(1) 
	FROM (
		SELECT id = 1
		FROM Message.MessageList AS L with(nolock)
		JOIN Message.ReceiveUser AS R ON R.MsgID = L.MsgID 
		JOIN Users.UserInfo AS U ON U.Userid = R.UserID 
		JOIN Area.area AS A ON A.AreaID = U.AreaID
		JOIN Area.Platform AS P ON P.PlatformID = A.PlatformID
		WHERE L.CreateTime > @dtCreatTime 
			AND (@chvTitle IS NULL OR L.Title Like @chvTitle) 
			AND (@intType IS NULL OR L.Type = @intType)
			AND (@intPlatformID IS NULL OR A.PlatformID = @intPlatformID)
			AND A.PlatformID in (select PlatformID from @Temp_PlatformID)	
	) AS A
	/*
	FROM Message.MessageList AS L with(nolock)
	JOIN Message.ReceiveUser AS R ON R.MsgID = L.MsgID 
	JOIN Users.UserInfo AS U ON U.Userid = R.UserID 
	JOIN Area.area AS A ON A.AreaID = U.AreaID
	JOIN Area.Platform AS P ON P.PlatformID = A.PlatformID
	WHERE L.CreateTime > @dtCreatTime 
		AND (@chvTitle IS NULL OR L.Title Like @chvTitle) 
		AND (@intType IS NULL OR L.Type = @intType)
		AND (@intPlatformID IS NULL OR A.PlatformID = @intPlatformID)
		AND A.PlatformID in (select PlatformID from @Temp_PlatformID)
	;*/
	;WITH tab AS 
	(
		SELECT rowid = ROW_NUMBER() over(order by L.CreateTime desc),
			A.PlatformID, 
			L.MsgID as Id,
			L.Title, 
			L.MsgContent,
			L.Type,
			U.UserID as FromUserID, 
			L.Sort,
			L.CreateTime,
			L.MsgSeq,
			P.Name as Platform 
		FROM Message.MessageList AS L with(nolock)
		JOIN Message.ReceiveUser AS R ON R.MsgID = L.MsgID 
		JOIN Users.UserInfo AS U ON U.Userid = R.UserID 
		JOIN Area.area AS A ON A.AreaID = U.AreaID
		JOIN Area.Platform AS P ON P.PlatformID = A.PlatformID
		WHERE L.CreateTime > @dtCreatTime 
			AND (@chvTitle IS NULL OR L.Title Like @chvTitle) 
			AND (@intType IS NULL OR L.Type = @intType)
			AND (@intPlatformID IS NULL OR A.PlatformID = @intPlatformID)
			AND A.PlatformID in (select PlatformID from @Temp_PlatformID)		 
	)
	--ORDER BY L.CreateTime DESC	

	SELECT * FROM tab WHERE rowid between @intPageSize * (@intPageIndex -1) + 1 and @intPageSize * @intPageIndex
	
END