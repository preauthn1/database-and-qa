USE [LogDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Money_WithdrawGet')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Money_WithdrawGet] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		CCC
-- Create date: 2019/7/16
-- Description:	代付 取得打款清单
-- 	2020/02/11 	Mars 			增加回傳UserID
--	2020/02/25	Mars			join各代付商自定義銀行代碼表
--	2020/03/10	Mars			增加回傳WithdrawData
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Money_WithdrawGet]
	@intGWID			int,
	@intConvertType		int,	--1:支付宝;2:银联
	@intStatus			int = 2	--审核通过
AS
BEGIN
	
	SET NOCOUNT ON

	--取得状态=2(审核通过) 的兑换清单
	SELECT TOP 5
	       C.ID,		--项目组订单号
	       C.Amount,	--支付金额
	       C.BankName,	--银行名称
	       C.RealName,	--帐户名
	       C.Account,	--卡号
	       U.LoginName, --手机号
	       ISNULL(ISNULL(GB.ThirdPartyBankCode, B.BankID), '0') as BankID, --银行编码  
		   ISNULL(B.Code, '0') as BankCode, --编码 
		   C.CreateIP,	--用戶IP
		   U.UserID, 	--玩家ID
		   PM.WithdrawData --代付資訊
	  FROM [LogDB].[Money].[ConvertLog] C with (nolock) 
	  left join CenterDB.Users.UserInfo U with (nolock) on C.UserID = U.UserID
	  left join CenterDB.Money.UnionpayBankCode B with (nolock) on U.UnionpayBank = B.Code 
	  left join CenterDB.Pay.ConvertGatewayBankSetting GB WITH (nolock) on C.GWID = GB.ConvertGatewayID AND B.Id = GB.UnionpayBankCodeID  
	  left join CenterDB.Payment.MerchantInfo PM WITH (nolock) on PM.GWID = C.GWID AND PM.PlatformID = C.PlatformID AND PM.Status = 1 
	 WHERE C.ConvertType = @intConvertType
	   AND C.GWID = @intGWID
	   AND C.Status = @intStatus

END
