
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UpdatePaymentMerchantStatus]
	@intMerchantId	int,
	@intStatus int,
	@chvRtnMsg varchar(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Payment.merchantInfo SET Status = @intStatus WHERE ID = @intMerchantId

	IF @@ROWCOUNT > 0
	BEGIN
	SET @chvRtnMsg = '更新狀態成功';
	RETURN 1
	END

	SET @chvRtnMsg = '更新狀態失敗';
	RETURN -1
END