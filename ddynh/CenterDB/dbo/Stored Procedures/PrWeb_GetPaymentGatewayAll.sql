

-- =============================================
-- Author:  Mars
-- Create date: 2019/07/04
-- Description: 取得全部支付渠道
--	2019/08/19  mars		增加status判斷及依system排序
--	2019/11/04	Mars		AE支付相關隱藏/關閉 #210
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPaymentGatewayAll]
(
	@chvRtnMsg			varchar(50) = '' 	OUTPUT --錯誤訊息
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT ID, GatewayCode, GatewayName, MerchantInfo, SupportPayin, SupportPayout, ReviseAmount, BankCodes, Status, Systems, Url  
	FROM Payment.PayGateway 
	WHERE Status = 1 
	AND Systems <> 1
	ORDER BY Systems ASC
	
	SET @chvRtnMsg = '操作成功'
	RETURN 1
END