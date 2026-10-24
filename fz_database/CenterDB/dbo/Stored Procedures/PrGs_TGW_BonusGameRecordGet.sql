

-- =============================================
-- Author:  Eddie
-- Create date: 2019/07/10
-- Description:	糖果屋Slot-取得BonusGameRecord
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_TGW_BonusGameRecordGet]
(
	@intUserID		INT,
	@chvMsg				VARCHAR(100)	OUTPUT
)
AS
BEGIN
SET NOCOUNT ON
	SELECT [ID],[UserID],[TurnID],[Location],[Money],[BonusID]
	FROM [CenterDB].[Game].[TGW_BonusGameRecord] WITH(NOLOCK)
	WHERE [USERID] = @intUserID
	
	SET @chvMsg = '操作成功'
	RETURN 1
END
