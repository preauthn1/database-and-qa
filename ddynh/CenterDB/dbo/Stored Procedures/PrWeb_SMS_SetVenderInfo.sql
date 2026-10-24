

-- =============================================
-- Author:  Mars
-- Create date: 2019/09/03
-- Description:	編輯簡訊商設置
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SMS_SetVenderInfo]
(
	@intAdminID	INT = NULL,
	@intSMSID	INT = NULL,
	@intPlatformID INT,
	@intSMSVenderID INT, 
	@chvInfo VARCHAR(200),
	@intStatus TINYINT = 0,
	@chvRtnMsg VARCHAR(200) OUTPUT
)
AS
BEGIN
	
	SET NOCOUNT ON

	DECLARE @SMSID INT = 0

	IF (@intSMSID IS NULL)
	BEGIN
		SELECT @intSMSID = SMSSettingId FROM ServerInfo.SMSSetting WHERE PlatformId = @intPlatformID AND SMSId = @intSMSVenderID

		IF (@intSMSID IS NULL)
		BEGIN
			INSERT INTO ServerInfo.SMSSetting(PlatformId, SMSId, SMSInfo, Status, CreateTime)
			VALUES(@intPlatformID, @intSMSVenderID, @chvInfo, @intStatus, getdate())
			IF (@@ROWCOUNT > 0)
			BEGIN
				SET @chvRtnMsg = '新增成功'
				RETURN 1
			END
			SET @chvRtnMsg = '新增失敗'
			RETURN -1
		END
	END

	SET @SMSID = @intSMSID;

	UPDATE ServerInfo.SMSSetting 
	SET SMSInfo = @chvInfo,
		Status = @intStatus,
		LastUpdateTime = getdate()
	WHERE SMSSettingId = @SMSID
	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @chvRtnMsg = '更新成功'
		RETURN 1
	END
	SET @chvRtnMsg = '更新失敗'
	RETURN -1
END