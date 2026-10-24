-- =============================================
-- Author:		Marshall
-- Create date: 2019-08-21
-- Description:	取得特定組織的角色已賦予幾個功能
-- =============================================
CREATE PROCEDURE [PrWeb_GetTargetRolesAssignRightCount]

		@OrgID		int		

AS
BEGIN



	SET NOCOUNT ON;


	SELECT roleRight.RoleID , count(*) as TotalRightCount
	FROM [Admin].[RoleRight] as roleRight with (NOLOCK)
	INNER JOIN  
	(
		SELECT RoleID from [Admin].[Role] with (NOLOCK)
		WHERE OrgID = @OrgID

	) as j on roleRight.RoleID = j.RoleID
	GROUP BY roleRight.RoleID




END