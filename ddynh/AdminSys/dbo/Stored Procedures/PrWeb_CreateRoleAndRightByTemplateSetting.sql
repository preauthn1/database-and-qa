-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_CreateRoleAndRightByTemplateSetting] 
(
	@targetOrgId		    INT,					--目標組織編號
	@prefixText				nvarchar(20)		    --前綴文字
)
AS
BEGIN

	DECLARE @existCount int;

	SET XACT_ABORT ON;

	BEGIN TRANSACTION

		-- Step 1. 先檢查是否已建過資料
		SET @existCount = (SELECT count(*) FROM [Admin].[Role] WHERE OrgID = @targetOrgId);

		IF @existCount > 0
			BEGIN

				SELECT 999;

			END
		ELSE
			BEGIN
				-- Step 2. 建立預設的role角色 (for該組織)
				INSERT INTO [Admin].[Role]
				SELECT @prefixText + ' ' + RoleName , '' , @targetOrgId , 0 , 0 , GETDATE() , RoleID from [Admin].[Role] 
				WHERE IsTemplateForCopy = 1


				-- Step 3. 建好角色後，從原本的templateRole複製權限(Right)
				INSERT INTO [Admin].[RoleRight]
				SELECT r.RoleID , roleRight.RightID from [Admin].[Role] as r
				INNER JOIN [Admin].[RoleRight] as roleRight on r.ParentTemplateID = roleRight.RoleID
				WHERE OrgID = @targetOrgId AND [ParentTemplateID] is not null

			END

			
		COMMIT TRAN

END