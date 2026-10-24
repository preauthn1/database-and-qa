-- =============================================
-- Author:  Mars
-- Create date: 2019/10/03
-- Description:	查询用户銀行记录依類型加總
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetBankLogGroupBySourceType]
(
	@intUserID			INT = NULL	
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT SourceTypeID, SUM(UpdateAmount) as UpdateAmount, PlatformID, AreaID
	FROM [Money].[BankLog] 
	WHERE UserID = @intUserID 
	GROUP BY SourceTypeID, PlatformID, AreaID
END
GO
