
-- =============================================
-- Author:  Mars
-- Create date: 2019/07/05
-- Description:	获取PayType信息
--	2019/11/04	Mars		AE支付相關隱藏/關閉 #210
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPaymentTypeAll]	
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
AS
BEGIN
	SELECT G.GatewayName as GWName, T.ID, T.GWID, T.Type, t.Currencies, T.BankCode, T.MinAmount, T.MaxAmount, T.AmountFixed, T.FixedAmount, T.Status 
	FROM [Payment].[PayGateway] AS G 
	JOIN [Payment].[PayType] AS T ON G.ID = T.GWID
	WHERE G.Systems <> 1
	ORDER BY GWID ASC, Type ASC, BankCode ASC
	
	SET @chvRtnMsg = '查詢成功'
	return 1
END