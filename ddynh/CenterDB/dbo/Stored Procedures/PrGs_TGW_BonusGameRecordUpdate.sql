
-- =============================================
-- Author:  Eddie
-- Create date: 2019/07/10
-- Description:	糖果屋Slot-新增BonusGameRecord或根據UserID + TurnID更新既有資料
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_TGW_BonusGameRecordUpdate]
(
	@intUserID		INT = 0,
	@intTurnID		INT = 0,
	@intLocation	INT = 0,
	@intMoney		BIGINT = 0,
	@intBonusID		INT=0,
	@chvMsg				VARCHAR(100)	OUTPUT
)
AS
BEGIN
SET NOCOUNT ON

	IF NOT Exists (Select 1 From [Game].[TGW_BonusGameRecord] where UserID=@intUserID and TurnID=@intTurnID)
	Begin
		Insert into [Game].[TGW_BonusGameRecord] ([UserID],[TurnID],[Location],[Money],[BonusID])
		Values (@intUserID, @intTurnID, @intLocation, @intMoney, @intBonusID)
	End
	Else
	Begin
		Update [Game].[TGW_BonusGameRecord] Set location=@intLocation where UserID=@intUserID and TurnID=@intTurnID
	End
	
	SET @chvMsg = '操作成功'
	RETURN 1
END