
-- =============================================
-- Author:		Mars
-- Create date: 2019/07/22
-- Description:	更新第三方金流代碼
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_UpdateTrandID] 
	@intOrderID int = 0,
	@chvTransID varchar(50) = null,
	@intGWID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@intGWID = 0)
		UPDATE Pay.OrderList SET TransID = @chvTransID WHERE Id = @intOrderID AND Status = 1
	ELSE
		UPDATE Pay.OrderList SET TransID = @chvTransID, GWID = @intGWID WHERE Id = @intOrderID AND Status = 1

	IF (@@ROWCOUNT > 0) 
		RETURN 1
	ELSE
		RETURN -1
END