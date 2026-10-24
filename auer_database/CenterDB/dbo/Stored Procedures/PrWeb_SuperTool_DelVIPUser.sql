
-- =============================================
-- Author:  alan
-- Create date: 20180903
-- Description:	刪除遊戲監控"
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_DelVIPUser]
(
	@intUserID int
)
AS
BEGIN

	SET NOCOUNT ON

	DELETE Game.SuperTool_VIPUser WHERE UserID = @intUserID

	RETURN 1
END
