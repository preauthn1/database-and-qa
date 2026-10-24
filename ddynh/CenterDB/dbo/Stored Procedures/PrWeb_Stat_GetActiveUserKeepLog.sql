-- =============================================
-- Author:  alan
-- Create date: 2018/11/30
-- Description:	有效會員留存
-- 2019-08-20	amy	增加@AdminID權限查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetActiveUserKeepLog]
	@intPlatformID 	INT = null,
	@intAdminID 	INT = 1
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)

	SELECT
	Convert(datetime,CAST(A.YYYYMMDD as varchar),112) as StatTime,
	A.id AS id,
	A.YYYYMMDD,
	B.[Name] AS [Platform],
	A.ActiveUsers,
	A.Day1Keep,
	A.Day3Keep,
	A.Day5Keep,
	A.Day7Keep,
	A.Day14Keep,
	A.Day30Keep,
	A.Day3Payrate,
	A.Day5Payrate,
	A.Day7Payrate
	FROM Stat.ActiveUserKeepLog AS A with (nolock)
	INNER JOIN [CenterDB].[Area].[Platform] AS B ON A.PlatformID = B.PlatformID
	WHERE ((@intPlatformID IS NULL or A.PlatformID = @intPlatformID) AND (A.PlatformID IN (SELECT PlatformID FROM #Temp_AccessRights)))
	ORDER BY YYYYMMDD DESC
	
	DROP TABLE #Temp_AccessRights

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetActiveUserKeepLog] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetActiveUserKeepLog] TO [xbuser]
    AS [dbo];

