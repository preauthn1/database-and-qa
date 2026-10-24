USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_GetPayTypeManagementAmountList')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_GetPayTypeManagementAmountList] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Marshall
-- Create date: 2019/09/03
-- Description:	獲取可用的支付方式(後台)
-- 	2019/12/27 	Mars 			增加返回Scale
--	2020/03/19	Mars			增加返回DisplayName
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_GetPayTypeManagementAmountList]	
	@intPlatformID INT = NULL
AS
BEGIN	
	
	SELECT	a.GWID,
			b.TypeID,
			a.ID AS PayTypeID,
			ISNULL(b.BankName,'') + ' (' + a.BankCode + ')' AS TypeName,
			a.Name AS DisplayName,
			a.TradeCode,
			b.SourceTypeID,
			ISNULL(d.Scale, 100) AS Scale,
			ISNULL(d.Priority , 1) AS [Priority], 
			CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 
				THEN ISNULL(d.FixedAmount, a.fixedAmount) 
				ELSE ISNULL(d.FixedAmount, ISNULL(a.fixedAmount, '10000,20000,30000,50000,60000,80000,90000,100000')) END AS AmountSort,
			CASE WHEN ISNULL(d.AmountFixed, a.amountFixed) = 1 THEN 0 ELSE 1 END AS IsRange,
			ISNULL(dbo.Fn_PaymentMinAmount(d.MinAmount, d.AmountFixed, d.FixedAmount),dbo.Fn_PaymentMinAmount(a.minAmount, a.amountFixed, a.fixedAmount)) AS MinValue,
			CASE WHEN ISNULL(d.MaxAmount, a.maxAmount) <> 0 THEN ISNULL(d.MaxAmount, a.maxAmount) ELSE 100000000 END AS MaxValue,
			c.GatewayName,
			CASE WHEN d.id is null THEN 0 ELSE d.id END AS PlatformPayTypeSettingId, 
			CASE WHEN d.status is null THEN 0 ELSE d.status END AS Status
	FROM [Payment].[PayType] AS a 
	JOIN [Payment].[BankCodeType] AS b ON a.BankCode = b.BankCode
	JOIN [Payment].[PayGateway] AS c ON a.GWID = c.ID and c.status = 1 
	JOIN [Payment].[MerchantInfo] AS m ON m.GWID = c.ID AND m.Status = 1 AND m.PlatformID = @intPlatformID 
	LEFT JOIN [Payment].[PlatformPayTypeSetting] AS d ON d.PayTypeID = a.id and d.PlatformID = @intPlatformID
	WHERE a.Type = 1 AND a.status = 1 AND TypeID IS NOT NULL
	ORDER BY c.Sort DESC, c.ID, d.id DESC, a.ID 
END
