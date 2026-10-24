
-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	获取支付金额接口, For Client
-- 2019/07/22 Mars		排除Payment.PayTypeDisable

-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPaymentAmountList]	
@intPlatformID		INT=NULL
AS
BEGIN
/*
	SELECT	a.GWID,
			b.TypeID,
			TypeName = a.BankCode,
			TradeCode = a.ID,
			b.SourceTypeID,
			Scale = b.Sort,
			[Status] = 1,
			--AmountSort = CASE WHEN a.amountFixed = 1 THEN a.fixedAmount ELSE '10000,20000,30000,50000,60000,80000,90000,100000' END, 
			AmountSort = CASE WHEN a.amountFixed = 1 THEN a.fixedAmount ELSE isnull(a.fixedAmount, '10000,20000,30000,50000,60000,80000,90000,100000') END, 
			IsRange = CASE WHEN a.amountFixed = 1 THEN 0 ELSE 1 END,
			MinValue = dbo.Fn_PaymentMinAmount(a.minAmount, a.amountFixed, a.fixedAmount),
			--MinValue = 1000,
			MaxValue = CASE WHEN a.maxAmount <> 0 THEN a.maxAmount ELSE 100000000 END,
			c.GatewayName,
			Popular = 0,
			c.Sort
	FROM [Payment].[PayType] AS a 
	LEFT JOIN [Payment].[BankCodeType] AS b ON a.BankCode = b.BankCode 
	LEFT JOIN [Payment].[PayGateway] AS c ON a.GWID = c.ID
	WHERE a.Type = 1 AND a.GWID IN (
		SELECT DISTINCT GWID FROM [Payment].[MerchantInfo] WHERE status = 1 AND PlatformID = @intPlatformID
	) AND TypeID IS NOT NULL
	AND a.ID NOT IN (SELECT PayTypeID FROM [Payment].[PayTypeDisable] WHERE PlatformID = @intPlatformID) 
	ORDER BY c.Sort DESC, c.ID, a.ID
	*/
		SELECT	a.GWID,
			b.TypeID,
			TypeName = a.BankCode,
			TradeCode = a.ID,
			b.SourceTypeID,
			Scale = b.Sort,
			[Status] = 1,
			AmountSort = CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 
				THEN ISNULL(d.FixedAmount, a.fixedAmount) 
				ELSE ISNULL(d.FixedAmount, ISNULL(a.fixedAmount, '10000,20000,30000,50000,60000,80000,90000,100000')) END,
			IsRange = CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 THEN 0 ELSE 1 END,
			MinValue = ISNULL(dbo.Fn_PaymentMinAmount(d.MinAmount, d.AmountFixed, d.FixedAmount),dbo.Fn_PaymentMinAmount(a.minAmount, a.amountFixed, a.fixedAmount)),
			MaxValue = CASE WHEN ISNULL(d.MaxAmount, a.maxAmount) <> 0 THEN ISNULL(d.MaxAmount, a.maxAmount) ELSE 100000000 END,
			c.GatewayName,
			Popular = 0,
			c.Sort
	FROM [Payment].[PayType] AS a 
	LEFT JOIN [Payment].[BankCodeType] AS b ON a.BankCode = b.BankCode 
	JOIN [Payment].[PayGateway] AS c ON a.GWID = c.ID AND c.status = 1 
	JOIN [Payment].[PlatformPayTypeSetting] AS d ON d.PayTypeID = a.id and d.PlatformID = @intPlatformID AND d.status = 1
	WHERE a.Type = 1 AND TypeID IS NOT NULL AND a.status = 1 
	ORDER BY c.Sort DESC, c.ID, a.ID
END