

-- =============================================
-- Author:  Mars
-- Create date: 2019/07/04
-- Description: 新增/更新支付渠道
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UpdatePaymentGateway]
(
	@chvGatewayCode 	varchar(20),
	@chvGatewayName 	varchar(20),
	@intMerchantInfo 	int,
	@tnySupportPayin 	tinyint,
	@tnySupportPayout 	tinyint,
	@tnyReviseAmount 	tinyint,
	@chvBankCodes 		varchar(200),
	@intID 				int = null 			OUTPUT, --主key
	@chvRtnMsg			varchar(50) = '' 	OUTPUT	--錯誤訊息
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT @intID = ID FROM Payment.PayGateway WHERE GatewayCode = @chvGatewayCode

	--檢查是否有重複thirdPartyCode
	IF (@intID IS NULL)
	BEGIN
		--新增支付渠道
		INSERT INTO Payment.PayGateway(GatewayCode, GatewayName, MerchantInfo, SupportPayin, SupportPayout, ReviseAmount, BankCodes, Status, CreateTime) 
		VALUES (@chvGatewayCode, @chvGatewayName, @intMerchantInfo, @tnySupportPayin, @tnySupportPayout, @tnyReviseAmount, @chvBankCodes, 1, getDate())
		--Get ID
		IF @@ROWCOUNT > 0
		BEGIN
			SET @intID = SCOPE_IDENTITY()
			SET @chvRtnMsg = '操作成功'
			RETURN 1
		END
		ELSE
		BEGIN
			SET @intID = 0
			SET @chvRtnMsg = '操作失敗'
			RETURN -1
		END	
	END
	ELSE
	BEGIN
		--更新支付渠道
		UPDATE Payment.PayGateway SET GatewayName = @chvGatewayName, MerchantInfo = @intMerchantInfo, SupportPayin = @tnySupportPayin, SupportPayout = @tnySupportPayout, ReviseAmount = @tnyReviseAmount, BankCodes = @chvBankCodes, 
				Status = 1, LastUpdateTime = getDate() 
		WHERE ID = @intID
		IF @@ROWCOUNT > 0
		BEGIN
			SET @chvRtnMsg = '操作成功'
			RETURN 1
		END
		ELSE
		BEGIN
			SET @chvRtnMsg = '操作失敗'
			RETURN -1
		END
	END
END