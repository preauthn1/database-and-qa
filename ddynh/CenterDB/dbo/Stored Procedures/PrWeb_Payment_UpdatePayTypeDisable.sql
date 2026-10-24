-- =============================================
-- Author:		Mars
-- Create date: 2019/07/21
-- Description:	變更Platform PayType 狀態
-- 2019/07/31 Mars 增加insert時的判斷, 當已存在就不新增
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_UpdatePayTypeDisable]	
	@intID INT = 0,
	@intPayTypeID INT = 0,		--PayTypeID
	@intPlatformID INT = 0,		--平台ID
	@intType INT = 0,			--狀態; 1:enable 2:disable
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Status int = -1;
	SET @chvRtnMsg = '变更失败'
				
	IF (@intType = 1)
	BEGIN
		if (@intID > 0) 
		BEGIN
			DELETE FROM Payment.PayTypeDisable WHERE ID = @intID;

			IF (@@ROWCOUNT > 0)
			BEGIN
				SET @chvRtnMsg = '变更成功'
				SET @Status = 1
			END
		END
	END

	ELSE
	BEGIN
		if (@intPayTypeID > 0 and @intPlatformID > 0) 
		BEGIN
			INSERT Payment.PayTypeDisable(PayTypeID, PlatformID) 
			SELECT DISTINCT @intPayTypeID as PayTypeID, @intPlatformID as PlatformID 
			FROM Payment.PayTypeDisable 
			WHERE NOT EXISTS (SELECT id FROM Payment.PayTypeDisable 
								WHERE PayTypeID = @intPayTypeID and PlatformID = @intPlatformID)

			IF (@@ROWCOUNT > 0)
				SET @chvRtnMsg = '变更成功';
			ELSE
				SET @chvRtnMsg = '资料已存在';
			SET @Status = 1
		END
	END

	RETURN @Status
END