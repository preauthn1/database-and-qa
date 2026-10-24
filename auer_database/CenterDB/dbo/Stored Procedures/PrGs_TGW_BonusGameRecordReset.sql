

-- =============================================
-- Author:  Eddie
-- Create date: 2019/07/10
-- Description:	糖果屋Slot-清除某個UserID的BonusGameRecord
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_TGW_BonusGameRecordReset]
(
	@intUserID		INT,
	@chvMsg				VARCHAR(100)	OUTPUT
)
AS
BEGIN
SET NOCOUNT ON
	Delete from [Game].[TGW_BonusGameRecord] where ID in (Select ID from [Game].[TGW_BonusGameRecord] with(nolock) where UserID=@intUserID)
	
	SET @chvMsg = '操作成功'
	RETURN 1
END
