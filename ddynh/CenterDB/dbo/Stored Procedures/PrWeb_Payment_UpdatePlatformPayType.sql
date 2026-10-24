-- =============================================
-- Author:		Mars
-- Create date: 2019/08/02
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_UpdatePlatformPayType]
	@intPlatformPayTypeId int = 0,
	@intPayTypeId int = 0,
	@intPlatformID int = 0,
	@intMinAmount int = null,
	@intMaxAmount int = null,
	@intIsRange tinyint = 0,
	@chvAmountList varchar(100) = null,
	@intStatus tinyint = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @intID int = NULL;

	IF (@intPlatformPayTypeId = 0) 
	BEGIN

		--若資料不存在，建立資料
		EXEC PrWeb_Payment_CreatePlatformPayTypeSetting_IfNotExist @intPayTypeId , @intPlatformID , @intID OUTPUT

	END
	ELSE
	BEGIN
		SET @intID = @intPlatformPayTypeId;
	END


	UPDATE Payment.PlatformPayTypeSetting 
	SET MinAmount = @intMinAmount, MaxAmount = @intMaxAmount, AmountFixed = @intIsRange, FixedAmount = @chvAmountList, Status = @intStatus, lastUpdateTime = getDate()
	WHERE ID = @intID


	IF (@@ROWCOUNT = 0)
	BEGIN
		RETURN -1
	END
	RETURN 1
END