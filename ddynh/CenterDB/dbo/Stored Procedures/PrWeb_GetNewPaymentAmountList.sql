
-- =============================================
-- Author:  Mars
-- Create date: 2019/07/22
-- Description:	获取支付金额接口 For Backend
-- 2019/08/06  mars 增加join Payment.MerchantInfo, 當有新增商戶設定時, 才會顯示
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetNewPaymentAmountList]	
@intPlatformID INT = NULL,
@intAdminID INT = NULL
AS
BEGIN	
	
	--SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)

	SELECT	a.GWID,
			b.TypeID,
			TypeName = isnull(b.BankName,'') + ' (' + a.BankCode + ')',
			TradeCode = a.ID,
			b.SourceTypeID,
			Scale = 10,
			d.Priority,
			AmountSort = CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 
				THEN ISNULL(d.FixedAmount, a.fixedAmount) 
				ELSE ISNULL(d.FixedAmount, ISNULL(a.fixedAmount, '10000,20000,30000,50000,60000,80000,90000,100000')) END,
			IsRange = CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 THEN 0 ELSE 1 END,
			MinValue = ISNULL(dbo.Fn_PaymentMinAmount(d.MinAmount, d.AmountFixed, d.FixedAmount),dbo.Fn_PaymentMinAmount(a.minAmount, a.amountFixed, a.fixedAmount)),
			MaxValue = CASE WHEN ISNULL(d.MaxAmount, a.maxAmount) <> 0 THEN ISNULL(d.MaxAmount, a.maxAmount) ELSE 100000000 END,
			c.GatewayName,
			Popular = 0,
			Sort = 0, 
			DisableId = CASE WHEN d.id is null THEN 0 ELSE d.id END, 
			Status = CASE WHEN d.status is null THEN 0 ELSE d.status END
	FROM [Payment].[PayType] AS a 
	JOIN [Payment].[BankCodeType] AS b ON a.BankCode = b.BankCode
	JOIN [Payment].[PayGateway] AS c ON a.GWID = c.ID and c.status = 1 
	JOIN [Payment].[MerchantInfo] AS m ON m.GWID = c.ID AND m.Status = 1 AND m.PlatformID = @intPlatformID 
	LEFT JOIN [Payment].[PlatformPayTypeSetting] AS d ON d.PayTypeID = a.id and d.PlatformID = @intPlatformID
	WHERE a.Type = 1 AND a.status = 1 AND TypeID IS NOT NULL
	ORDER BY c.Sort DESC, c.ID, d.id DESC, a.ID 
END