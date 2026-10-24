-- =============================================
-- Author:  jason
-- Create date: 2019/04/11
-- Description: USER 查詢系統預設比例
-- 2019/09/12 	Mars		增加UserID查詢全民代理分成比例
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_UserAgent_GetAgentTaxList]
(
	@intUserID INT = NULL
)
AS
BEGIN

	set nocount on

	EXEC [Club02].[dbo].[PrPs_UserAgent_GetAgentTaxList] 
		@intUserID = @intUserID

	return 1
END






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_UserAgent_GetAgentTaxList] TO [GameUser]
    AS [dbo];

