-- =============================================
-- Author:  Jason
-- Create date: 2019/03/19
-- Description:	總遊戲在線人數 (原本使用ORM改為呼叫SP取資料)
-- 2019-08-16	amy	增加@Admin權限查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetMaxOnlineUserCount]
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
	DECLARE @GameID		INT = 0

	IF(DATEDIFF(DAY,@StartTime,@EndTime) > 3)
	BEGIN
		SET @StartTime = DATEADD(DAY,-3,@dtEndTime)
		SET @EndTime = @dtEndTime
	END

	/*  取得權限查詢  */
	------------------------------------------------------------------------------------------------------
	SELECT * INTO #Temp_AccessRights FROM [CenterDB].dbo.Fn_GetAdminAccessRights(@intAdminID)
	------------------------------------------------------------------------------------------------------

	/*  回傳統計數據  */
	------------------------------------------------------------------------------------------------------
SELECT	
[StatTime],
A.[PlatformID],
B.[AreaName],
[PCCount],
[AndroidCount],
[IOSCount],
[TotalCount]
INTO #SQLTempTable
FROM [CenterDB].[Stat].[DAULog] AS A WITH (NOLOCK)
INNER JOIN [CenterDB].[Area].[Area] AS B WITH (NOLOCK) ON A.AreaID = B.AreaID
WHERE
(@PlatformID = A.[PlatformID] OR @PlatformID = 0) AND (A.[PlatformID] IN (select PlatformId from #Temp_AccessRights))
AND (@AreaID = A.[AreaID] OR @AreaID = 0) AND (A.[AreaID] IN (select AreaID from #Temp_AccessRights))
AND @GameID = [GameID]
AND [StatTime] >= @StartTime AND [StatTime] <= @EndTime
ORDER BY [StatTime] DESC,A.[PlatformID] ASC,A.[AreaID]

IF(@PlatformID = 0)
BEGIN
SELECT
[StatTime],
'0' AS [PlatformID],
'全部' AS [AreaName],
SUM([PCCount]) AS [PCCount],
SUM([AndroidCount]) AS [AndroidCount],
SUM([IOSCount]) AS [IOSCount],
SUM([TotalCount]) AS [TotalCount]
FROM #SQLTempTable
GROUP BY [StatTime]
ORDER BY [StatTime] DESC,[PlatformID] ASC
END
ELSE
BEGIN
SELECT * FROM #SQLTempTable
ORDER BY [StatTime] DESC,[PlatformID] ASC
END

DROP TABLE #Temp_AccessRights
DROP TABLE #SQLTempTable
	------------------------------------------------------------------------------------------------------
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetMaxOnlineUserCount] TO [GameUser]
    AS [dbo];
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetMaxOnlineUserCount] TO [xbuser]
    AS [dbo];
GO
