
-- =============================================
-- Author:		Mars
-- Create date: 2019/07/08
-- Description:	<Description,,>
-- 2019/07/17	Mars	支援platform
-- 2019/09/04    Mars    修正當UUID未傳時, 不update UUID
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UpdatePaymentMerchantInfo]
	@chvGWCode varchar(50),
	@chvInfo varchar(2000),
	@chvUuid varchar(100) = NULL,
	@intPlatformId int,
	@intMerchantId int = null OUTPUT,
	@chvRtnMsg	varchar(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NowTime DATETIME = GETDATE(),
			@intID int = null;
	
	SELECT @intID = ID FROM Payment.PayGateway WHERE GatewayCode = @chvGWCode

	IF (@intID IS NULL)
	BEGIN
		SET @chvRtnMsg = '查無Pay Gateway';
		RETURN -1
	END

	IF (@intMerchantId = 0)
	BEGIN
		INSERT INTO Payment.MerchantInfo(GWID, InfoData, PlatformID, Status, Uuid, CreateTime) VALUES(@intID, @chvInfo, @intPlatformId, 1, @chvUuid, @NowTime);
		IF (@@ROWCOUNT = 0)
		BEGIN
			SET @chvRtnMsg = '新增失敗';
			RETURN -1
		END
		SET @intMerchantId = SCOPE_IDENTITY()
		SET @chvRtnMsg = '新增成功';
		RETURN 1
	END
	ELSE
	BEGIN
		IF (@chvUuid IS NULL)
			UPDATE Payment.MerchantInfo SET InfoData = @chvInfo, PlatformID = @intPlatformId WHERE ID = @intMerchantId
		ELSE
			UPDATE Payment.MerchantInfo SET InfoData = @chvInfo, Uuid = @chvUuid, PlatformID = @intPlatformId WHERE ID = @intMerchantId
		IF @@ROWCOUNT > 0
		BEGIN
			SET @chvRtnMsg = '操作成功';
			RETURN 1
		END
		ELSE
		BEGIN
			SET @chvRtnMsg = '操作失敗';
			RETURN -1
		END
	END
END