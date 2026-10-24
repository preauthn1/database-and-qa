-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<绑定游客账号、銀行卡>
--  2019/08/06  mars	增加UserType的判斷
--  2019/10/15	mars	(暫時)先移除綁定遊客號錯誤訊息, 直接使用PrPs_User_BindGuest的error message	
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_User_BindGuestUnionpay]
@intUserID			INT,					--用户ID
@chvCode			VARCHAR(32),			--验证码
@chvTel				VARCHAR(32),			--绑定手机号码
@chvPassword		VARCHAR(32),			--账号密码
@chvRealName		VARCHAR(64),			--銀行账号对应的姓名
@chvUnionpayBank	VARCHAR(5),				--所屬銀行代號
@chvUnionpayAccount	VARCHAR(64),			--銀行账号
@tintCodeType		tinyint = 7,			--验证码类型 1注册,2找回密码 3找回银行密码 4第一次綁定支付帳號 5修改支付帳號
@chvErrMsg			VARCHAR(128) OUTPUT		--返回消息
AS
BEGIN

DECLARE @intResult		int = 0
--DECLARE @chvExLoginName	VARCHAR(32)
DECLARE @intUserType	tinyint = NULL
DECLARE @chvCer			VARCHAR(32) = NULL

--检查账号类型
SELECT	@intUserType = UserType 
	FROM [CenterDB].Users.UserInfo 
	WHERE
		UserID = @intUserID AND
		UserType <> 2
 
IF @intUserType IS NULL
BEGIN
	SET @chvErrMsg = '查无帐号'
	RETURN -1
END

--账号是游客需先绑定手機
IF @intUserType = 3
BEGIN
	EXEC @intResult = [CenterDB].[dbo].[PrPs_User_BindGuest]
		@intUserID = @intUserID,
		@chvCode = @chvCode,
		@chvTel = @chvTel,
		@chvPassword = [REDACTED],
		@tintCodeType = @tintCodeType,
		@chvErrMsg = @chvErrMsg OUTPUT
		
	IF @intResult < 1
	BEGIN
		--SET @chvErrMsg = '绑定手机失败'
		--RETURN @intResult
		RETURN -1
	END	

	UPDATE centerdb.Users.UserCode
		SET VCode = @chvCode
		WHERE Tel = @chvTel 
		AND DATEADD(ss,10*60,CreateCodeTime) >= GETDATE() 
		AND CodeType = @tintCodeType
		AND VCode = ''

	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @chvErrMsg = '新增失敗'
		RETURN -1
	END
END

--凭证:游戏玩家证书
SELECT @chvCer = [CerCode]
	FROM [CenterDB].[Game].[Certification] with(nolock) 
	WHERE [UserID] = @intUserID

IF @chvCer IS NULL
BEGIN
	SET @chvErrMsg = '查无帐号证书'
	RETURN -1
END

EXEC @intResult = [CenterDB].[dbo].[PrPs_BindUnionPayAccount]
	@intUserID = @intUserID,
	@chvCer	= @chvCer,			
	@chvCode = @chvCode,		
	@chvRealName = @chvRealName,
	@chvUnionpayBank = @chvUnionpayBank,
	@chvUnionpayAccount	= @chvUnionpayAccount,
	@tintCodeType = @tintCodeType,
	@chvErrMsg = @chvErrMsg	OUTPUT

	RETURN @intResult
END