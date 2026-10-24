-- =============================================
-- Author:  alan
-- Create date: 2018/09/29
-- Description:	充值留存
-- 2019-08-20	amy	增加@AdminID權限查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetChargeKeepLog]
@intHdType int=null,
@intPlatformID int=null,
@intAdminID		INT = 1
AS
BEGIN
	SET NOCOUNT ON

	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	
	SELECT
	Convert(datetime,CAST(A.YYYYMMDD as varchar),112) as StatTime,
	A.id AS id,
	A.YYYYMMDD,
	B.[Name] AS [Platform],
	A.RegChargeUsers,
	A.HDType,
	A.Day1Keep,
	A.Day2Keep,
	A.Day7Keep,
	A.Day30Keep
	FROM Stat.ChargeKeepLog AS A with (nolock)
	INNER JOIN [CenterDB].[Area].[Platform] AS B ON A.PlatformID = B.PlatformID
	WHERE (@intHdType is null or A.HDType = @intHdType)
	AND((@intPlatformID IS NULL or A.PlatformID = @intPlatformID) AND (A.PlatformID IN (SELECT PlatformID FROM #Temp_AccessRights)))
	ORDER BY YYYYMMDD DESC,HDType ASC

DROP TABLE #Temp_AccessRights

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetChargeKeepLog] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetChargeKeepLog] TO [xbuser]
    AS [dbo];

