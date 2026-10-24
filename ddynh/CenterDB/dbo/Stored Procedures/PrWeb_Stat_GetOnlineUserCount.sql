-- =============================================
-- Author:  Jason
-- Create date: 2019/03/19
-- Description:	總遊戲在線人數 (原本使用ORM改為呼叫SP取資料)
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetOnlineUserCount]
(
	@intPlatformID	INT = 0,			--平台編號 0:全部 1:
	@intAreaID		INT = 0,			--渠道編號
	@dtStartTime	DATETIME = NULL,	--開始時間
	@dtEndTime		DATETIME = NULL,	--結束時間
	@intAdminID		INT = 1
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @PlatformID	INT = ISNULL(@intPlatformID,0)
	DECLARE @AreaID		INT = ISNULL(@intAreaID,0)
	DECLARE @StartTime	DATETIME = ISNULL(@dtStartTime,'2000-01-01 00:00:00.000')
	DECLARE @EndTime	DATETIME = ISNULL(@dtEndTime,'2100-01-01 00:00:00.000')

	IF(DATEDIFF(DAY,@StartTime,@EndTime) > 3)
	BEGIN
		SET @StartTime = DATEADD(DAY,-3,@dtEndTime)
		SET @EndTime = @dtEndTime
	END

	/*  回傳統計數據  */
	------------------------------------------------------------------------------------------------------
SELECT * INTO #Temp_AccessRights FROM [CenterDB].dbo.Fn_GetAdminAccessRights(@intAdminID)

SELECT
B.Id,
A.[PlatformID],
A.AreaName,
B.TotalCount,
B.PCCount,
B.IOSCount,
B.AndroidCount,
B.[StatTime]
INTO #SQLTable
FROM [CenterDB].[Area].[Area] AS A WITH (NOLOCK)
INNER JOIN [CenterDB].[Stat].[TotalGameOnLineLogArea] AS B ON A.AreaID = B.AreaID
WHERE
(@intPlatformID = A.[PlatformID] OR @intPlatformID = 0) AND (A.[PlatformID] IN (SELECT PlatformID FROM #Temp_AccessRights))
AND (@intAreaID = A.[AreaID] OR @intAreaID = 0) AND (A.[AreaID] IN (SELECT AreaID FROM #Temp_AccessRights))
AND [StatTime] BETWEEN @StartTime AND @EndTime
ORDER BY [StatTime] DESC

IF(@intPlatformID = 0)
BEGIN

SELECT 
'0' AS Id,
'0' AS PlatformID,
'全部' AS AreaName,
SUM(TotalCount) AS TotalCount,
SUM(PCCount) AS PCCount,
SUM(IOSCount) AS IOSCount,
SUM(AndroidCount) AS AndroidCount,
StatTime
FROM #SQLTable
GROUP BY [StatTime]

END
ELSE
BEGIN

SELECT * FROM #SQLTable

END

DROP TABLE #Temp_AccessRights
DROP TABLE #SQLTable
	------------------------------------------------------------------------------------------------------
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetOnlineUserCount] TO [GameUser]
    AS [dbo];
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetOnlineUserCount] TO [xbuser]
    AS [dbo];
GO
