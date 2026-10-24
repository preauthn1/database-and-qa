

-- =============================================
-- Author:  Mars
-- Create date: 20191204
-- Description:	超端 JLBPK 取得監控人數
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_JLBPK_GetVIPUser]
(
	@intUserID INT = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT J.UserID,
		ISNULL(J.UserWeight, 0) AS UserWeight,
		ISNULL(J.TargetMoney, 0) AS TargetMoney,
		ISNULL(J.AccumulatedMoney, 0) AS AccumulatedMoney,
		ISNULL(J.Finish,0) as Finish,
		J.Status,
		J.Operator,
		J.CreateTime,
		J.LastUpdateTime 
	FROM Game.SuperTool_JLBPK_VIPUser J WITH (NOLOCK)
	WHERE (@intUserID IS NULL OR J.UserID = @intUserID)
	
	RETURN 1
END