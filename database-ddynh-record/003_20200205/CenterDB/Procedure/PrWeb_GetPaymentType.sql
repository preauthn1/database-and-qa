USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_GetPaymentType')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_GetPaymentType] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Mars
-- Create date: 2019/07/04
-- Description: 取得支付方式
--  2019/10/03	Mars		增加返回BankName
--	2019/11/04	Mars		AE支付相關隱藏/關閉 #210
--	2020/03/19	Mars		修正查詢PayType錯誤
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_GetPaymentType]
(
	@intGWID INT = null,
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @SelectCount int = 0;

	SELECT G.GatewayName as GWName, 
			T.ID, 
			T.GWID, 
			T.Type, 
			T.Currencies, 
			T.BankCode, 
			ISNULL(B.BankName, T.BankCode) as BankName, 
			T.MinAmount, 
			T.MaxAmount, 
			T.AmountFixed, 
			T.FixedAmount, 
			T.Status, 
			T.TradeCode,
			T.Name as DisplayName 
	FROM [Payment].[PayGateway] AS G 
	JOIN [Payment].[PayType] AS T ON G.ID = T.GWID AND T.Type = 1 
	LEFT JOIN [Payment].[BankCodeType] AS B ON B.BankCode = T.BankCode
	WHERE (G.ID = @intGWID OR @intGWID IS NULL) 
	ORDER BY GWID ASC, Type ASC, T.BankCode ASC
	
	SET @chvRtnMsg = '操作成功'
	RETURN 1
END
