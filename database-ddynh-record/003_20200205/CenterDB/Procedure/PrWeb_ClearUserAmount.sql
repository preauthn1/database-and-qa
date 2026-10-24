USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_ClearUserAmount')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_ClearUserAmount] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Louis
-- Create date: 2020/02/17
-- Description:	管理員一鍵清理用戶錢包金幣&銀行金幣
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_ClearUserAmount]
@intUserID			INT,			        --用户ID
@chvIPAddress		VARCHAR(15),			--IP地址
@chvMemo			VARCHAR(128),           --说明
@chvErrMsg			VARCHAR(128) OUTPUT     --错误消息
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @BankAmount BIGINT
	DECLARE @CashAmount BIGINT
	DECLARE @lngUpdateAmount BIGINT = 0
	DECLARE @chvErrMsg_Cash VARCHAR(128)
	DECLARE @chvErrMsg_Bank VARCHAR(128)
	DECLARE @lngCurrentAmount BIGINT
	SELECT @CashAmount = [Amount] * -1 FROM [Money].[Cash] WITH(NOLOCK) WHERE [UserID] = @intUserID
	SELECT @BankAmount = [Amount] * -1 FROM [Money].[Bank] WITH(NOLOCK) WHERE [UserID] = @intUserID
	
	DECLARE @intResult_Cash int = 0
	DECLARE @intResult_Bank int = 0

	IF ISNULL(@BankAmount,0) <> 0
	BEGIN
		EXEC @intResult_Bank = [dbo].[PrWeb_UpdateUserBank]
		@intAdminID = 1,
		@intUserID = @intUserID,
		@sintSourceType = 13001, --直接傳入指定SourceType
		@lngUpdateAmount = @BankAmount,
		@chvIPAddress = @chvIPAddress,
		@chvMemo = @chvMemo,
		@lngCurrentAmount = @lngCurrentAmount OUT,
		@chvErrMsg = @chvErrMsg_Bank OUT
	END
	ELSE
	BEGIN
		SET @intResult_Bank = 1
	END

	IF ISNULL(@CashAmount,0) <> 0
	BEGIN
		EXEC @intResult_Cash = [dbo].[PrWeb_UpdateUserCash]
		@intUserID = @intUserID,
		@sintSourceType = 13001, --直接傳入指定SourceType
		@lngUpdateAmount = @CashAmount,
		@chvIPAddress = @chvIPAddress,
		@chvMemo = @chvMemo,
		@lngCurrentAmount = @lngCurrentAmount OUT,
		@chvErrMsg = @chvErrMsg_Cash OUT
	END
	ELSE
	BEGIN
		SET @intResult_Cash = 1
	END

	IF @intResult_Bank = 1 AND @intResult_Cash = 1
	BEGIN
		SET @chvErrMsg = '操作成功:一键清理该帐号保险箱及身上金币'
		RETURN 1
	END

	IF @intResult_Bank = 1 AND @intResult_Cash = -1
	BEGIN
		SET @chvErrMsg = '清理保险箱金币操作成功; 清理身上金币' + @chvErrMsg_Cash
		RETURN -1
	END

	IF @intResult_Bank = -1 AND @intResult_Cash = 1
	BEGIN
		SET @chvErrMsg = '清理保险箱金币' + @chvErrMsg_Bank + '; 清理身上金币操作成功'
		RETURN -1
	END

	IF @intResult_Bank = -1 AND @intResult_Cash = -1
	BEGIN
		SET @chvErrMsg = '清理保险箱金币' + @chvErrMsg_Bank + '; 清理身上金币' + @chvErrMsg_Cash
		RETURN -1
	END

	RETURN 1
END