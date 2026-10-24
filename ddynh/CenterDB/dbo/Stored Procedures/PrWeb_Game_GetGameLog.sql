-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<Description,,>
--	2018/03/22	Jason		調整語法改為LINKEDSERVER呼叫回傳資料表
--  2018/04/19	alan		增加顯示欄位 ,c.UserID AS 'User.ID' ,因為前端沒有顯示
--	2018/05/09	Jason		調整INNER改LEFT對應
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Game_GetGameLog] 
(
	@intAdminID			INT = NULL,
	@intServerID		INT = NULL,
	@intGameID			INT = NULL, 
	@intUserID			INT = NULL,
	@chvIpAddress		VARCHAR(50) = NULL,
	@intHDtype			INT = NULL,
	@chvHDcode			VARCHAR(50) = NULL,
	@logInBeginTime		DATETIME = NULL, 
	@logInEndTime		DATETIME = NULL,
	@logOutBeginTime	DATETIME = NULL,
	@logOutEndTime		DATETIME = NULL,
	@intAreaID			INT = NULL,
	@intPageIndex		INT = 1,
	@intPageSize		INT = 20,
	@intPageCount		INT	= 0			OUTPUT		
)
AS
BEGIN


	CREATE TABLE #Temp_UserGameLog
		(
			rowNum INT,
			[LogID] INT,
			[UserID] INT,
			[ServerID] INT,
			[LoginMoney] BIGINT,
			[Amount] BIGINT,
			[TaxAmount] BIGINT,
			[WinCount] INT,
			[LoseCount] INT,
			[DrawCount] INT,
			[GameTime] INT,
			[IPAddress] VARCHAR(15),
			[HDCode] VARCHAR(64),
			[HDType] TINYINT,
			[LoginTime] DATETIME,
			[LogoutTime] DATETIME,
			[GameID] INT,
			[AreaID] INT
		)

	INSERT INTO #Temp_UserGameLog
	EXEC [LOGDBLINKEDSERVER].[LogDB].[dbo].[PrWeb_Game_GetGameLog]
		@intAdminID = @intAdminID,
		@intServerID = @intServerID,
		@intUserID = @intUserID,
		@chvIpAddress = @chvIpAddress,
		@tnyHDtype = @intHDtype,
		@chvHDcode = @chvHDcode,
		@dtLoginStartTime = @LoginBeginTime,
		@dtLoginEndTime = @LoginEndTime,
		@dtLogoutStartTime = @LogoutBeginTime,
		@dtLogoutEndTime = @LogoutEndTime,
		@intGameID = @intGameID,
		@intAreaID = @intAreaID,
		@intPageIndex = @intPageIndex,
		@intPageSize = @intPageSize,
		@intPageCount = @intPageCount OUTPUT
	
	
	SELECT	rowNum,
			a.*
			,b.GameID  AS 'GameServer.GameID'
			,b.ServerName  AS 'GameServer.ServerName'
			,b.ShowName  AS 'GameServer.ShowName'
			,b.ClientAddr  AS 'GameServer.ClientAddr'
			,b.NotifyAddr  AS 'GameServer.NotifyAddr'
			,b.Money  AS 'GameServer.Money'
			,b.LastUpdateTime  AS 'GameServer.LastUpdateTime'
			,c.UserID AS 'User.ID'
			,c.FaceID AS 'User.FaceID'
			,c.LoginName AS 'User.LoginName'
			,c.NickName AS 'User.NickName'
			,c.Password AS 'User.Password'
			,c.Sex AS 'User.Sex'
			,c.HDType AS 'User.HDType'
			,c.HDCode AS 'User.HDCode'
			,c.UserType AS 'User.UserType'
			,c.CreateTime AS 'User.CreateTime'
			,c.CreateIPAddress AS 'User.CreateIPAddress'
			,c.LastLogonTime AS 'User.LastLogonTime'
			,c.LastLogonIPAddress as 'User.LastLogonIPAddress'
			,e.Name AS 'User.Area.Platform.Name'
	FROM #Temp_UserGameLog AS A
		LEFT JOIN ServerInfo.GameServerList AS b WITH (NOLOCK) ON a.ServerID = b.ServerID
		LEFT JOIN Users.UserInfo AS c WITH (NOLOCK) ON a.UserID = c.UserID
		LEFT JOIN Area.Area AS d WITH (NOLOCK) ON c.AreaID = d.AreaID
		LEFT JOIN Area.Platform AS e WITH (NOLOCK) ON d.PlatformID = e.PlatformID
		

	SET @intPageCount = ISNULL(@intPageCount,0)
	
	DROP TABLE #Temp_UserGameLog
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Game_GetGameLog] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Game_GetGameLog] TO [xbuser]
    AS [dbo];

