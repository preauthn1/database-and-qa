
CREATE PROCEDURE [dbo].[PrPs_Event_BonusCode_Get]
	@intUserID			INT, 
	@chvInviteCode		VARCHAR(20),
	@chvErrMsg			Varchar(50) OUT
AS
SET NOCOUNT ON
	DECLARE @Temp_GetCode	TABLE ([Code] CHAR(12))
	IF len(@chvInviteCode) < 5 OR @chvInviteCode NOT IN ('MYJ8RXOP', 'IPSLF6G8')
	BEGIN
		SET @chvErrMsg = '邀请码无效'
		RETURN -1
	END

	IF EXISTS(SELECT 1 FROM [Event].[BonusCode] WITH(nolock) WHERE UserID = @intUserID)
	BEGIN
		SET @chvErrMsg = '您的帐号已经领取过奖励'
		RETURN -1
	END

	/*  取用兌換碼  */
	UPDATE TOP (1) [Event].[BonusCode]
	SET [Status] = 1, UserID = @intUserID, GetTime = GETDATE(), InviteCode = @chvInviteCode
	OUTPUT DELETED.Code INTO @Temp_GetCode
	WHERE
		[Status] = 0
	if @@ROWCOUNT = 0 
	BEGIN
		SET @chvErrMsg = '兑换码己领取完毕'
		RETURN -1
	END

	DECLARE @intMsgID INT
	DECLARE @chvCode VARCHAR(12)
	DECLARE @chvContent VARCHAR(255)
	
	SELECT @chvCode = Code FROM @Temp_GetCode

	SET @chvContent = '恭喜您获得了免费看三天成人视频的兑换码 : 

点击序号立即复制
{{' + @chvCode + '}}

点击链接立即前往
<a href="https://example.invalid">https://example.invalid</a>'

--select @intUserID, @chvContent, @chvCode

	EXEC [dbo].[PrPs_SendSysMail]
	@intUserID = @intUserID,
	@chvTitle = '精品视频兑换码',
	@chvContent = @chvContent,
	@intSort = 0,
	@intMsgID = @intMsgID


	SET @chvErrMsg = ''
	RETURN 1