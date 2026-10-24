
-- =============================================
-- Author:  Mars
-- Create date: 2019/12/12
-- Description: 取得經典21點動態水線區間表
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JDESYD_GetSystemPoolSetting]
(
	@intFlagID		INT		--初1 中2 高3 级场
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT FlagID,
			AreaNo,
			XVariation,
			ConditionOdds
	FROM [Game].[SuperTool_JDESYD_SystemPoolSetting] A WITH (NOLOCK)
	WHERE FlagID = @intFlagID

	RETURN 1

END