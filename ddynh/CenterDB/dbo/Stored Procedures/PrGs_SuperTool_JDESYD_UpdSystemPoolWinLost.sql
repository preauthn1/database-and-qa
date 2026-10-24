
-- =============================================
-- Author:  Mars
-- Create date: 2019/12/12
-- Description: 經典21點新增/更新系統水池输赢记录
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JDESYD_UpdSystemPoolWinLost]
(
	@intFlagID		INT,		--初1 中2 高3 级场
	@lngBetMoney	BIGINT,		--經典21點玩家總押注金額
	@lngBetCount	INT,		--總下注次數
	@lngPoolAmount	BIGINT		--系統抽水金額
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE [Game].[SuperTool_JDESYD_SystemPoolWinLost]
	SET BetMoney = BetMoney + @lngBetMoney,
		BetCount = BetCount + @lngBetCount,
		PoolAmount = PoolAmount + @lngPoolAmount
	WHERE FlagID = @intFlagID

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO [Game].[SuperTool_JDESYD_SystemPoolWinLost](FlagID,BetMoney,BetCount,PoolAmount)
		VALUES(@intFlagID, @lngBetMoney, @lngBetCount, @lngPoolAmount)
	END

	SELECT FlagID,
			AverageBet,
			Factor,
			PoolAmount
	FROM [Game].[SuperTool_JDESYD_SystemPoolWinLost] A WITH (NOLOCK)
	WHERE FlagID = @intFlagID

	RETURN 1

END