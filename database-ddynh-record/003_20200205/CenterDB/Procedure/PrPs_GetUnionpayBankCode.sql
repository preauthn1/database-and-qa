USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrPs_GetUnionpayBankCode')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrPs_GetUnionpayBankCode] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  alan
-- Create date: 2018-3-14
-- Description:	获取銀聯卡銀行代號
-- 	2020/02/12 	Mars 			增加判斷條件where show = 1
-- =============================================
ALTER PROCEDURE [dbo].[PrPs_GetUnionpayBankCode]
(
	@intUserID INT = NULL
)
AS
BEGIN
	SELECT B.Code, B.Bankname 
	FROM CenterDB.Money.UnionpayBankCode AS B WITH (NOLOCK)
	WHERE Show = 1
END