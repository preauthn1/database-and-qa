

-- =============================================
-- Author:  Mars
-- Create date: 2019/12/03
-- Description:	加勒比海撲克 - 游戏server更新監控
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JLBPK_UpdVIPUser]
(
	@intUserID INT,
	@intUserWeight INT,		--玩家拿牌權重
	@intTargetMoney BIGINT,		--玩家目標金額
	@intAccumulatedMoney BIGINT,	--累積金額
	@chvOperator VARCHAR(50) = NULL	-- 操作人員
)
AS
BEGIN

	SET NOCOUNT ON

	IF ISNULL(@intUserID,0) = 0
	BEGIN
		RETURN -1 --或是其他的資訊，讓呼叫方知道傳入ID為空
	END
	
	IF EXISTS(SELECT * FROM Game.SuperTool_JLBPK_VIPUser WHERE UserID = @intUserID)
	BEGIN
		UPDATE Game.SuperTool_JLBPK_VIPUser 
		SET UserWeight = @intUserWeight,
		AccumulatedMoney = @intAccumulatedMoney,
		Operator = ISNULL(@chvOperator, Operator)
		WHERE UserID = @intUserID

		RETURN 1
	END
	ELSE 
	BEGIN
		INSERT INTO Game.SuperTool_JLBPK_VIPUser(UserID, UserWeight, TargetMoney, AccumulatedMoney, Operator, CreateTime)
		VALUES(@intUserID, @intUserWeight, @intTargetMoney, @intAccumulatedMoney, @chvOperator, GETDATE())
		
		IF (@@ROWCOUNT = 0)
		BEGIN
			RETURN -1
		END
		RETURN 1
	END
END