

-- =============================================
-- Author:  Mars
-- Create date: 2019/12/02
-- Description:	加勒比海撲克 - 超端設定
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JLBPK_GetSetting]
(
	@intFlagID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT [FlagID], [FlowBase], [PlayerWeight], [DealerWeight], [DealerTargetMoney], [CheatRate], [DealerWin], [PlayerWin], [DealerNotGood] 
	FROM [CenterDB].[Game].[SuperTool_JLBPK_Setting]
	WHERE [FlagID] = @intFlagID 

	RETURN 1
END