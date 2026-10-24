-- =============================================
-- Author:		Marshall
-- Create date: 2019-08-19
-- Description:	取得每個平台對到幾個組織了
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetEachPlatformOrganizationCount]
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT PlatformID , count(*) as TotalOrgCount 
	FROM [Admin].[OrganizationPlatformMapping]
	GROUP BY PlatformID

END