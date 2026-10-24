-- =============================================
-- Author:  alan
-- Create date: 2019/03/27
-- Description:	遊戲在線人數明細
-- 2019-08-15	amy	調整權限設定
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetGameOnlineUserLog]
(
@intAdminID		int = 1,
@intPlatformID  int = 0,
@intGameID		int=null,
@dtStartTime	datetime=null,
@dtEndTime		datetime=null
)
AS
BEGIN

SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)

IF(@intPlatformID = 0)
	SET @intPlatformID = NULL

SELECT
L.TotalCount as TotalCount,
L.IOSCount as IOSCount,
L.AndroidCount as AndroidCount,
L.StatTime, 
L.PlatformID,
P.Name as PlatformName,
L.GameID,
G.GameName as [Game.GameName]
INTO #SQLTable
from CenterDB.ServerInfo.GameList G with (nolock)
left join [Stat].GameOnLineUserLog L with (nolock) on G.GameID = l.GameID
left join CenterDB.Area.Platform P  with (nolock) on L.PlatformID=P.PlatformID
where 
(L.PlatformID = ISNULL(@intPlatformID, L.PlatformID)) AND (L.PlatformID in (select PlatformId from #Temp_AccessRights))
AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
AND (@intGameID IS NULL OR L.GameID = @intGameID)
ORDER BY Stattime DESC,L.GameID ASC

IF(@intPlatformID IS NULL OR @intPlatformID = 0)
BEGIN

SELECT 
SUM(TotalCount) as TotalCount,
SUM(IOSCount) as IOSCount,
SUM(AndroidCount) as AndroidCount,
StatTime,
0 as PlatformID,
'全部' as PlatformName,
GameID,
[Game.GameName]
FROM #SQLTable
GROUP BY StatTime,GameID,[Game.GameName]

END
ELSE
BEGIN
SELECT * FROM #SQLTable
END

DROP TABLE #Temp_AccessRights
DROP TABLE #SQLTable

END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetGameOnlineUserLog] TO [GameUser]
    AS [dbo];
GO
