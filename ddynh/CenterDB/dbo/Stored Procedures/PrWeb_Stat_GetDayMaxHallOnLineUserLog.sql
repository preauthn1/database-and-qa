-- =============================================
-- Author:		<amy>
-- Create date: <2019-08-16>
-- Description:	<大廳最高在線人數>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetDayMaxHallOnLineUserLog]
	-- Add the parameters for the stored procedure here
@intAdminID		INT = 1,
@intPlatformID  INT,
@dtStartTime	DATETIME = NULL,
@dtEndTime		DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT * INTO #Temp_AccessRights FROM [CenterDB].dbo.Fn_GetAdminAccessRights(@intAdminID)

IF(@intPlatformID = 0)
BEGIN
SELECT
'0' AS ID,
MAX(TotalCount) AS TotalCount,
MAX(PCCount) AS PCCount,
MAX(IOSCount) AS IOSCount,
MAX(AndroidCount) AS AndroidCount,
'0' AS PlatformID,
MAX(StatTime) AS StatTime
FROM [CenterDB].[Stat].[DayMaxHallOnLineUserLog]
WHERE StatTime BETWEEN @dtStartTime AND @dtEndTime
AND (PlatformID IN (SELECT PlatformID FROM #Temp_AccessRights)) AND (PlatformID <> 0)
GROUP BY CONVERT(CHAR,StatTime,23)
END
ELSE
BEGIN
SELECT
ID,
TotalCount
PCCount,
IOSCount,
AndroidCount,
PlatformID,
StatTime
FROM [CenterDB].[Stat].[DayMaxHallOnLineUserLog]
WHERE StatTime BETWEEN @dtStartTime AND @dtEndTime
AND (PlatformID = @intPlatformID) AND (PlatformID IN (SELECT PlatformID FROM #Temp_AccessRights))
END

DROP TABLE #Temp_AccessRights

END