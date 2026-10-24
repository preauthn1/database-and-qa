

-- =============================================
-- Author:  Mars
-- Create date: 20191204
-- Description:	游戏JLBPK 取得監控名單
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_JLBPK_UpdVIPUser]
(
	@intUserID INT,
	@intUserWeight INT = NULL,
	@lngTargetMoney  BIGINT = NULL,
	@lngAccumulatedMoney BIGINT = NULL,
	@intStatus INT = NULL,
	@chvOperator VARCHAR(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE Game.SuperTool_JLBPK_VIPUser
	SET UserWeight = ISNULL(@intUserWeight, UserWeight),
		TargetMoney = ISNULL(@lngTargetMoney, TargetMoney),
		AccumulatedMoney = ISNULL(@lngAccumulatedMoney, AccumulatedMoney),
	Status = ISNULL(@intStatus, Status),
	Operator = ISNULL(@chvOperator, Operator),
	LastUpdateTime = GETDATE()
	WHERE UserID = @intUserID

	RETURN 1
END