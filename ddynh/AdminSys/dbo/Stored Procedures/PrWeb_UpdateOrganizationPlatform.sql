
CREATE PROCEDURE [dbo].[PrWeb_UpdateOrganizationPlatform]
   @OrgID				INT	,
   @SelectedPlatforms dbo.ListInt READONLY
      AS	  
	  BEGIN
	  
			SET XACT_ABORT ON;

			BEGIN TRAN TRAN_1; 

				--先刪除全部以存在的--
				DELETE [Admin].[OrganizationPlatformMapping] 
				WHERE OrgID = @OrgID

				--再寫入本次勾選的--
				INSERT INTO [Admin].[OrganizationPlatformMapping]
				SELECT @OrgID ,[Value] 
				FROM @SelectedPlatforms

			COMMIT TRAN TRAN_1;  

	  END