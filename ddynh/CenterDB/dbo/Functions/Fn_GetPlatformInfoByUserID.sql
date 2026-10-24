-- =============================================
-- Author:		Marshall
-- Create date: 2019-11-21
-- Description:	根據userID取得平台號
-- =============================================
CREATE FUNCTION Fn_GetPlatformInfoByUserID
(	
	@userID int
)

RETURNS @tempMyTable TABLE (LoginName nvarchar(200) , AreaID int , AreaName nvarchar(500) , PlatformID int , PlatformName nvarchar(500)) 

AS
BEGIN
	INSERT INTO @tempMyTable
	SELECT LoginName , a.AreaID , a.AreaName , p.PlatformID , p.Name as PlatformName
	FROM Users.UserInfo as u
	left join Area.Area as a on u.AreaID = a.AreaID
	left join Area.[Platform] as p on a.PlatformID = p.PlatformID
	WHERE u.UserID = @userID
	RETURN
END