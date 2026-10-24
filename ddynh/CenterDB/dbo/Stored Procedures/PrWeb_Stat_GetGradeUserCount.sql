-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<统计等级人数>
-- 2019-08-08	Amy	加上AdminID設置權限
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetGradeUserCount]
	@intAdminID INT = 1
AS
BEGIN

--DECLARE @PlatformAreaByAdminUserTable TABLE(AdminID INT, PlatformID INT, AreaID INT)

--INSERT INTO @PlatformAreaByAdminUserTable
--EXEC [CenterDB].[dbo].[PrWeb_GetPlatformAreaByAdminUser]
--@intAdminID = @intAdminID

SELECT G.Id,G.Amount,ISNULL(A.UserCount,0) AS UserCount 
FROM Users.GradeSetting AS G
LEFT JOIN 
(
	SELECT GradeID,COUNT(1) AS UserCount FROM CenterDB.Users.UserInfo WITH(NOLOCK)
	--WHERE AreaID IN (SELECT AreaID FROM @PlatformAreaByAdminUserTable)
	WHERE AreaID IN (SELECT AreaID FROM dbo.Fn_GetAdminAccessRights(@intAdminID))
	GROUP BY GradeID
) AS A ON G.Id = A.GradeID
	
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetGradeUserCount] TO [GameUser]
    AS [dbo];
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetGradeUserCount] TO [xbuser]
    AS [dbo];
GO
