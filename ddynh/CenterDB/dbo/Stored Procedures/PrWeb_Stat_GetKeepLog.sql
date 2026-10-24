-- =============================================
-- Author:  Jason
-- Create date: 2018/03/27
-- Description:	<统计留存率>
-- 2019-08-20	amy	平台與渠道為0的處理，Admin權限來源更改
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetKeepLog]
(
	@intAdminID		INT = null,
	@intPlatformID	INT = 0,			--平台編號
	@intAreaID		INT = 0,			--渠道編號
	@dtStartTime	DATETIME = NULL,	--開始時間
	@dtEndTime		DATETIME = NULL		--結束時間
)
AS
BEGIN
	SET NOCOUNT ON

SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)

SELECT
A.[PlatformID],
A.[AreaID],
ISNULL(A.[TotalRegCount],0) AS [RegCount],
ISNULL(B.[OneDayKeep],0) AS [OneDayKeep],
ISNULL(B.[TwoDayKeep],0) AS [TwoDayKeep],
ISNULL(B.[WeekKeep],0) AS [WeekKeep],
ISNULL(B.[MonthKeep],0) AS [MonthKeep],
A.[StatTime]
INTO #SQLTempTable
FROM [CenterDB].Stat.RegUserLog AS A
INNER JOIN [CenterDB].[Stat].[KeepLog] AS B WITH (NOLOCK) ON A.PlatformID = B.PlatformID AND A.AreaID = B.AreaID AND A.StatTime = B.StatTime
WHERE A.StatTime BETWEEN @dtStartTime AND @dtEndTime
AND (A.PlatformID <> 0) AND (A.PlatformID IN (SELECT PlatformID  FROM #Temp_AccessRights))
AND A.AreaID <> 0 AND (A.AreaID IN (SELECT AreaID  FROM #Temp_AccessRights))

IF (@intPlatformID = 0)
BEGIN

SELECT
'0' AS PlatformID,
'0' AS AreaID,
SUM(RegCount) AS RegCount,
SUM(OneDayKeep) AS OneDayKeep,
SUM(TwoDayKeep) AS TwoDayKeep,
SUM(WeekKeep) AS WeekKeep,
SUM(MonthKeep) AS MonthKeep,
StatTime
FROM #SQLTempTable
GROUP BY StatTime
ORDER BY [StatTime] DESC

END
ELSE

IF(@intAreaID = 0)
BEGIN

SELECT
PlatformID,
'0' AS AreaID,
SUM(RegCount) AS RegCount,
SUM(OneDayKeep) AS OneDayKeep,
SUM(TwoDayKeep) AS TwoDayKeep,
SUM(WeekKeep) AS WeekKeep,
SUM(MonthKeep) AS MonthKeep,
StatTime
FROM #SQLTempTable
WHERE PlatformID = @intPlatformID
GROUP BY PlatformID, StatTime
ORDER BY [StatTime] DESC

END
ELSE
BEGIN

SELECT * FROM #SQLTempTable
WHERE PlatformID = @intPlatformID
AND AreaID = @intAreaID
ORDER BY [StatTime] DESC

END

DROP TABLE #Temp_AccessRights
DROP TABLE #SQLTempTable


END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetKeepLog] TO [GameUser]
    AS [dbo];
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetKeepLog] TO [xbuser]
    AS [dbo];
GO
