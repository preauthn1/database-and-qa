

-- =============================================
-- Author:  Mars
-- Create date: 2019/12/03
-- Description:	加勒比海撲克 - 游戏server刪除監控
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_JLBPK_DelVIPUser]
(
	@intUserID INT
)
AS
BEGIN

	SET NOCOUNT ON

	IF ISNULL(@intUserID,0) = 0
	BEGIN
		RETURN -1 --或是其他的資訊，讓呼叫方知道傳入ID為空
	END
	
	IF EXISTS(SELECT UserID FROM Game.SuperTool_JLBPK_VIPUser WHERE UserID = @intUserID)
	BEGIN
		DELETE Game.SuperTool_JLBPK_VIPUser 
		WHERE UserID = @intUserID
	END
	
	RETURN 1
END