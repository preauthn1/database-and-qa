
-- =============================================
-- Author:  Mars
-- Create date: 2019/12/12
-- Description: 經典21點重置系統水池; 
--					當水池金額大於0時, 會重置為0
--					如未指定FlagID, 將會全部重置
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_SuperTool_JDESYD_ResetSystemPool]
(
	@intFlagID INT = NULL		--初1 中2 高3 级场
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE [Game].[SuperTool_JDESYD_SystemPoolWinLost] 
	SET PoolAmount = 0 
	WHERE PoolAmount > 0 
	AND (@intFlagID IS NULL OR FlagID = @intFlagID)

END