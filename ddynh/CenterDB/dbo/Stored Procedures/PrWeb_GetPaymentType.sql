

-- =============================================
-- Author:  Mars
-- Create date: 2019/07/04
-- Description: 取得支付方式
--  2019/10/03	Mars		增加返回BankName
--	2019/11/04	Mars		AE支付相關隱藏/關閉 #210
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPaymentType]
(
	@chvGWCode varchar(50) = null,
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @SelectCount int = 0;

	IF (@chvGWCode is null)
	BEGIN
		SELECT G.GatewayName as GWName, T.ID, T.GWID, T.Type, t.Currencies, T.BankCode, ISNULL(B.BankName, T.BankCode) as BankName, T.MinAmount, T.MaxAmount, T.AmountFixed, T.FixedAmount, T.Status 
		FROM [Payment].[PayGateway] AS G 
		JOIN [Payment].[PayType] AS T ON G.ID = T.GWID AND T.Type = 1
		LEFT JOIN [Payment].[BankCodeType] AS B ON B.BankCode = T.BankCode
		WHERE G.Systems <> 1
		ORDER BY GWID ASC, Type ASC, T.BankCode ASC
	END

	ELSE
	BEGIN
		SELECT G.GatewayName as GWName, T.ID, T.GWID, T.Type, t.Currencies, T.BankCode, ISNULL(B.BankName, T.BankCode) as BankName, T.MinAmount, T.MaxAmount, T.AmountFixed, T.FixedAmount, T.Status 
		FROM [Payment].[PayGateway] AS G 
		JOIN [Payment].[PayType] AS T ON G.ID = T.GWID AND T.Type = 1
		LEFT JOIN [Payment].[BankCodeType] AS B ON B.BankCode = T.BankCode
		WHERE G.GatewayCode = @chvGWCode 
		AND G.Systems <> 1
		ORDER BY GWID ASC, Type ASC, T.BankCode ASC
	END

	SET @SelectCount = @@ROWCOUNT

	IF (@SelectCount > 0)
	BEGIN
		SET @chvRtnMsg = '操作成功'
	END
	--SET @chvRtnMsg = '查無資料'
	RETURN 1
END