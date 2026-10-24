

-- =============================================
-- Author:  Mars
-- Create date: 2019/07/04
-- Description: 取得支付渠道
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPaymentGateway]
(
	@intPayTypeID INT = 0,
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT G.ID, G.GatewayCode, G.GatewayName, G.MerchantInfo, G.SupportPayin, G.SupportPayout, G.ReviseAmount, G.BankCodes, G.Status, G.Systems, G.Url 
	FROM Payment.PayGateway AS G
	JOIN Payment.PayType AS P ON P.GWID = G.ID 
	WHERE P.ID = @intPayTypeID
	
	SET @chvRtnMsg = '操作成功'
	RETURN 1
END