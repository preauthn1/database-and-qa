


-- =============================================
-- Author:  Mars
-- Create date: 2019/12/02
-- Description:	加勒比海撲克 - 超端 Server取得莊家牌型權重
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JLBPK_GetDealerWeight]
(
	@intFlagID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT [DealerWeightID], [FlagID], [TableNo], [CardPattern], [Weight] 
	FROM [CenterDB].[Game].[SuperTool_JLBPK_DealerWeight]
	WHERE (@intFlagID IS NULL OR [FlagID] = @intFlagID) 
	ORDER BY [FlagID] ASC, [TableNo] ASC, [CardPattern] ASC

	RETURN 1
END