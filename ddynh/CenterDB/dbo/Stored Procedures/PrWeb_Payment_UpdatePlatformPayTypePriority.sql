-- =============================================
-- Author:		Marshall
-- Create date: 2019/09/04
-- Description:	更新權重或新建資料
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_UpdatePlatformPayTypePriority]	
	@intPayTypeID INT ,		--PayTypeID
	@intPlatformID INT,		--平台ID
	@intPriority  INT 		--權重
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @existID INT;
	
	BEGIN
	
		--若資料不存在，建立資料
		EXEC PrWeb_Payment_CreatePlatformPayTypeSetting_IfNotExist @intPayTypeId , @intPlatformID , @existID OUTPUT

	END
	

	UPDATE Payment.PlatformPayTypeSetting 
	SET Priority = @intPriority 
	WHERE ID = @existID
	

	SELECT @existID


	RETURN
END