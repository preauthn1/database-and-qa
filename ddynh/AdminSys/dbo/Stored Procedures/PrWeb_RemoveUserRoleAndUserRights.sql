-- =============================================
-- Author:		Marshall
-- Create date: 2019-11-01
-- Description:	若凍結後台帳號，會一併清除權限
-- =============================================
CREATE PROCEDURE PrWeb_RemoveUserRoleAndUserRights	
	@intAdminUserID int
AS
BEGIN
	
	DELETE from [Admin].[UserRole] 
	WHERE UserID = @intAdminUserID

	DELETE from [Admin].[UserRight] 
	WHERE UserID = @intAdminUserID

END