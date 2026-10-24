-- =============================================
-- Author:		Amy
-- Create date: 2019-10-18
-- Description:	新增第三方支付資料庫設定
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_InsertThirdPartyPayGatewayPayType]
	-- Add the parameters for the stored procedure here
	@chvPayGatewayCode VARCHAR(20),
	@chvPayGatewayName VARCHAR(10),
	@chvPayGatewayUrl VARCHAR(100),
	@chvPayGatewayBankCodes VARCHAR(200),
	@chvPayTypeBankCodes VARCHAR(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @intGWID INT
	
	--add 支付商 paygateway
	--查詢是否有此支付
	SELECT @intGWID = ID  FROM CenterDB.Payment.PayGateway
	WHERE GatewayCode = @chvPayGatewayCode

	IF(@intGWID IS NULL)
	BEGIN
		--若沒有則新增資料
		INSERT INTO CenterDB.Payment.PayGateway(GatewayCode, GatewayName, MerchantInfo, SupportPayin, SupportPayout, ReviseAmount, BankCodes, [Status], CreateTime, Systems, [Url]) 
		VALUES(@chvPayGatewayCode, @chvPayGatewayName, 0, 1, 0, 0, @chvPayGatewayBankCodes, 1, getdate(), 2, @chvPayGatewayUrl);
		SET @intGWID = @@IDENTITY
	END
	ELSE
	BEGIN
		--若有則更新資料
		UPDATE CenterDB.Payment.PayGateway
		SET GatewayName = @chvPayGatewayName, BankCodes = @chvPayGatewayBankCodes, [Url] = @chvPayGatewayUrl, LastUpdateTime = getdate()
		WHERE ID = @intGWID
	END

	--add 支付商 paytype
	INSERT INTO CenterDB.Payment.PayType(GWID, [Type], Currencies, BankCode, minAmount, maxAmount, amountFixed, [Status], CreateTime) 
	SELECT @intGWID AS GWID, 1, 'CNY', Value AS BankCode, 1000, 100000, 0, 1, getdate()
	FROM CenterDB.dbo.fn_split(@chvPayTypeBankCodes, ',') AS A
	WHERE NOT EXISTS (
		SELECT BankCode FROM CenterDB.Payment.PayType AS B 
		WHERE GWID = @intGWID AND A.Value = B.BankCode
	)

	RETURN 1
END