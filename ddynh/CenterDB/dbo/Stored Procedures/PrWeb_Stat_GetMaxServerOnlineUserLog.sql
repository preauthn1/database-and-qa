-- =============================================
-- Author:  alan
-- Create date: 2019/03/27
-- Description:	房間最高在線人數
-- 2019-08-16	amy	調整權限查詢來源
-- 2019-08-20	amy	聯運的權限設定刪除
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetMaxServerOnlineUserLog]
@intAdminID		int,
@intPlatformID  int,
@intGameID		int=null,
@intServerID	int=null,
@dtStartTime	datetime=null,
@dtEndTime		datetime=null
AS
BEGIN
	--撈出該用戶可讀取的全部平台、渠道
	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	

	--加總
	IF @intPlatformID=0
	SELECT
		SUM(L.TotalCount) as TotalCount,
		SUM(L.IOSCount) as IOSCount,
		SUM(L.AndroidCount) as AndroidCount,
		L.StatTime, 
		0 as PlatformId,
		'全部' as  PlatformName,
		L.ServerID,
		S.ServerName,
		G.GameName
		from  [CenterDB].[Stat].DayMaxServerOnLineUserLog L with (nolock) 
		left join CenterDB.ServerInfo.GameServerList S on L.ServerID = S.ServerID
		left join CenterDB.Area.Platform P with (nolock) on L.PlatformID=P.PlatformID
		left join CenterDB.ServerInfo.GameList G with (nolock) on G.GameID = S.GameID
		where 
		L.PlatformID in (select PlatformId from #Temp_AccessRights)
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		AND (@intServerID IS NULL OR L.ServerID = @intServerID)
		GROUP BY Stattime,L.ServerID,S.ServerName,G.GameName
		ORDER BY Stattime DESC,G.GameName ASC, L.ServerID ASC
	--個別
	ELSE
		SELECT
		L.TotalCount as TotalCount,
		L.IOSCount as IOSCount,
		L.AndroidCount as AndroidCount,
		L.StatTime, 
		L.PlatformID,
		P.Name as PlatformName,
		S.ServerName,
		G.GameName
		from  [CenterDB].[Stat].DayMaxServerOnLineUserLog L with (nolock) 
		left join CenterDB.ServerInfo.GameServerList S on L.ServerID = S.ServerID
		left join CenterDB.Area.Platform P with (nolock) on L.PlatformID=P.PlatformID
		left join CenterDB.ServerInfo.GameList G with (nolock) on G.GameID = S.GameID
		where 
		--L.PlatformID in (select PlatformId from @Temp_PlatformID)
		(L.PlatformID = @intPlatformID) AND (L.PlatformID in (select PlatformId from #Temp_AccessRights))
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		AND (@intServerID IS NULL OR L.ServerID = @intServerID)
		ORDER BY Stattime DESC,G.GameName ASC, L.ServerID ASC

		DROP TABLE #Temp_AccessRights
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetMaxServerOnlineUserLog] TO [GameUser]
    AS [dbo];
GO
