-- =============================================
-- Author:		Mars
-- Create date: 2019/08/02
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_UpdatePlatformPayTypeStatus]	
	@intType INT = 0,			--狀態; 1:enable 2:disable
	@intID INT = null,
	@intPayTypeID INT = 0,		--PayTypeID
	@intPlatformID INT = 0,		--平台ID
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @chvRtnMsg = '变更失败'

	IF (@intType = 2) 
		SET @intType = 0;

	IF (@intID = 0) 
	BEGIN
	
		--若資料不存在，建立資料
		EXEC PrWeb_Payment_CreatePlatformPayTypeSetting_IfNotExist @intPayTypeId , @intPlatformID , @intID OUTPUT

	END

	UPDATE Payment.PlatformPayTypeSetting SET Status = @intType WHERE ID = @intID
	
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @chvRtnMsg = '新增成功'
		RETURN 1
	END
	
	RETURN -1
END