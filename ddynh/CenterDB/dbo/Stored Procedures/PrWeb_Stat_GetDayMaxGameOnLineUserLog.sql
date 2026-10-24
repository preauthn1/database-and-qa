-- =============================================
-- Author:  alan
-- Create date: 2019/03/27
-- Description:	遊戲最高在線人數
-- 2019-08-16	amy	調整權限查詢來源
-- 2019-08-20	amy	聯運權限限制刪除
-- 2019-08-22	amy	加上遊戲名稱
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetDayMaxGameOnLineUserLog]
@intAdminID		int,
@intPlatformID  int,
@intGameID		int=null,
@dtStartTime	datetime=null,
@dtEndTime		datetime=null
AS
BEGIN

	--撈出該用戶可讀取的全部平台、渠道
	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	

	--加總
	if @intPlatformID=0
		SELECT
		SUM(L.TotalCount) as TotalCount,
		SUM(L.IOSCount) as IOSCount,
		SUM(L.AndroidCount) as AndroidCount,
		L.StatTime, 
		0 as PlatformId,
		'全部' as  PlatformName,
		G.GameName as [Game.GameName]
		from  [Stat].DayMaxGameOnLineUserLog L with (nolock) 
		left join CenterDB.Area.Platform P with (nolock) on L.PlatformID=P.PlatformID
		inner join CenterDB.ServerInfo.GameList as G with (nolock) on L.GameID = G.GameID
		where 
		L.PlatformID in (select PlatformId from #Temp_AccessRights)
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		AND (@intGameID IS NULL OR L.GameID = @intGameID)
		GROUP BY Stattime,L.GameID,G.GameName
		ORDER BY Stattime DESC,L.GameID ASC
	--個別
	else
		SELECT
		L.TotalCount as TotalCount,
		L.IOSCount as IOSCount,
		L.AndroidCount as AndroidCount,
		L.StatTime, 
		L.PlatformID,
		P.Name as PlatformName,
		G.GameName as [Game.GameName]
		from  [Stat].DayMaxGameOnLineUserLog L with (nolock) 
		left join CenterDB.Area.Platform P  with (nolock) on L.PlatformID=P.PlatformID
		inner join CenterDB.ServerInfo.GameList as G with (nolock) on L.GameID = G.GameID
		where 
		(L.PlatformID = @intPlatformID) AND (L.PlatformID in (select PlatformId from #Temp_AccessRights))
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		AND (@intGameID IS NULL OR L.GameID = @intGameID)
		ORDER BY Stattime DESC,L.GameID ASC

	DROP TABLE #Temp_AccessRights
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetDayMaxGameOnLineUserLog] TO [GameUser]
    AS [dbo];
GO
