USE CenterDB
GO

DECLARE @now DATETIME = getdate(),
		@chvGatewayCode NVARCHAR(20) = 'LongJuPay',
		@chvGatewayName NVARCHAR(20) = '龙聚',
		@chvMerchantInfo NVARCHAR(200) = '{"MERCHANT_NO":{"Display":"商户号编号","Type":"text","Require":"true"},"MERCHANT_KEY":{"Display":"商户号密钥","Type":"text","Require":"true"}}',
		@intPayin INT = 1,
		@intPayout INT = 0,
		@chvBankCode NVARCHAR(100) = 'CNY_ZHIFUBAO_QR,CNY_QUICKPASS_H5',
		@chvUrl NVARCHAR(100) = 'http://example.invalid',
		@intGWID INT,
		@chvPayType NVARCHAR(20)

--支付廠商
IF NOT EXISTS (SELECT * FROM Payment.PayGateway WITH (NOLOCK) WHERE GatewayCode = @chvGatewayCode)
BEGIN
	INSERT INTO Payment.PayGateway(GatewayCode, GatewayName, merchantInfo, SettingInfo, SupportPayin, SupportPayout, reviseAmount, bankcodes, status, createTime, url, Systems, sort) 
	VALUES(@chvGatewayCode, @chvGatewayName, 0, @chvMerchantInfo, @intPayin, @intPayout, 0, @chvBankCode, 1, getdate(), @chvUrl, 2, 0)

	SET @intGWID = SCOPE_IDENTITY();
END
ELSE
	SELECT @intGWID = ID FROM Payment.PayGateway WITH (NOLOCK) WHERE GatewayCode = @chvGatewayCode

--支付方式
SET @chvPayType = 'ZHIFUBAO_QR'
IF NOT EXISTS (SELECT * FROM Payment.PayType WITH (NOLOCK) WHERE GWID = @intGWID AND BankCode = @chvPayType)
BEGIN
	INSERT INTO Payment.PayType(GWID, Type, Currencies, BankCode, minamount, maxamount, amountfixed, status, createtime) 
	VALUES (@intGWID, 1,'CNY', 'ZHIFUBAO_QR', 2000, 1000000, 0, 1, @now)
END

SET @chvPayType = 'QUICKPASS_H5'
IF NOT EXISTS (SELECT * FROM Payment.PayType WITH (NOLOCK) WHERE GWID = @intGWID AND BankCode = @chvPayType)
BEGIN
	INSERT INTO Payment.PayType(GWID, Type, Currencies, BankCode, minamount, maxamount, amountfixed, status, createtime) 
	VALUES (@intGWID, 1,'CNY', '', 2000, 1000000, 0, 1, @now)
END
