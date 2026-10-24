-- =============================================
-- Author:  Jason
-- Create date: 2018/08/01
-- Description:	活動資料回傳、贈送金幣、領取獎勵


--	2019/10/23		Mars			登入七天金額改由後台設置 #161
--	2019/11/06		Mars			update Users.EventLog時增加判斷, 當5分鐘內不能再重複領取
--	2019/11/06		Marshall		資料結構大改

-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Event_LoginBonus]
(
	@intUserID			INT,
	@chvIPAddress		VARCHAR(40),
	@LoginTimes			INT = 0				OUTPUT,
	@GiftCash		BIGINT = 0				OUTPUT,
	@lngCurrentAmount	BIGINT = 0			OUTPUT,
	@chvRtnMsg			VARCHAR(100) = ''	OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	declare @nowtime datetime = getdate()
	declare @sintSourceType int = 21001
	declare @chvMemo varchar(20) = '登入奖励送金币'
	declare @bonusamount bigint = 0 --登入獎勵
	declare @flowAmount bigint = 0	--登入獎勵稽核流水
	declare @platformID int
	declare @eventSettingID int = 0;

	set @LoginTimes = 0
	set @chvRtnMsg = ''

	SET @platformID = (SELECT PlatformID FROM Fn_GetPlatformInfoByUserID (@intUserID))
	SET @eventSettingID = (SELECT top 1 ID FROM [Users].[EventSetting] with (nolock) where EventType = 1 AND PlatformID = @platformID AND [Status] = 1)
	
	if not exists (select top 1 1 from [Users].[EventSetting] with (nolock) where starttime <= @nowtime and endtime > @nowtime and Id = @eventSettingID)
	begin
		set @chvRtnMsg = '活动不存在'
		return -1
	end


	declare @intPlatformID int
	declare @chargeamount bigint
	declare @binding varchar(32)
	declare @intAreaid int
	declare @eventType int = 1;  ---請參考enum定義的 ApplyEventTypeEnum

	select @chargeamount = (sumcharge+SumAgentCharge), @binding = [LoginName],@intAreaid = [AreaID] from [Users].[UserInfo] with (nolock) where userid = @intUserID
	select @intPlatformID = PlatformID from [Area].[Area] with (nolock) where [AreaID] = @intAreaID
	select @LoginTimes = Sum([GrantTimes]) from [Users].[EventLog] with (nolock) where eventSettingID = @eventSettingID and [LoginName] = @binding

	--最低存款金額限制
	select @giftcash = (select top 1 RuleValue from [Event].[EventSettingRuleItem] where EventSettingID = @eventSettingID AND RuleType = 2001)

	set @LoginTimes = isnull(@LoginTimes,0)
	set @chargeamount = isnull(@chargeamount,0)

	if exists (select top 1 1 from [Users].[EventLog] with (nolock) where eventSettingID = @eventSettingID and [LoginName] = @binding and datediff(day,[UpdateTime],@nowtime) = 0)
	begin
		set @chvRtnMsg = '今日已领过奖励'
		return 0
	end


	DECLARE @TempLogonBonus	TABLE (	[Day] INT, [BonusAmount] INT, [FlowAmount] INT )

	
	--透過另一支SP，取得登入獎勵設置
	INSERT INTO @TempLogonBonus
	EXEC [dbo].[PrGs_Event_GetLoginEventSetting] 
			@intUserID = @intUserID	
			

	--登入獎勵次數
	DECLARE @intLogonBonusCount INT

	SELECT @intLogonBonusCount = COUNT(*) FROM @TempLogonBonus
	
	if (@LoginTimes >= @intLogonBonusCount)
	begin
		set @chvRtnMsg = CONCAT('已领超过', @intLogonBonusCount, '次限制')
		return -2
	end

	if (@chargeamount < @giftcash)
	begin
		set @chvRtnMsg = '充值金额不足'
		return -3
	end

	if (@binding LIKE 'Fast%')
	begin
		set @chvRtnMsg = '账号未绑定'
		return -4
	end
	
	--獲取登入該天的獎勵金及稽核流水
	SELECT @bonusamount = BonusAmount, @flowAmount = FlowAmount FROM @TempLogonBonus WHERE [Day] = (@LoginTimes + 1)
	

	if (@bonusamount <= 0)
	begin
		set @chvRtnMsg = '奖励金额设置为0元，无法领取'
		return -5
	end

	if exists (select top 1 1 from [Users].[EventLog] with (nolock) where eventSettingID = @eventSettingID and [LoginName] = @binding and userid = @intUserID)
	begin
		update [Users].[EventLog]
		set [GrantTimes] = [GrantTimes] + 1,
			[UpdateTime] = @nowtime,
			[LoginName] = @binding
		where
			eventSettingID = @eventSettingID
			and [LoginName] = @binding and UserID = @intUserID
			AND UpdateTime < DATEADD(MINUTE, -5, @nowtime)
	end
	else
	begin
		insert into [Users].[EventLog]
			([UserID],[UpdateTime],[GrantTimes],[LoginName],[EventSettingID],[EventType])
		values
			(@intUserID,@nowtime,1,@binding,@eventSettingID,@eventType)
	end

	if (@@rowcount <> 1)
	begin
		set @chvRtnMsg = '新增活动资格失败'
		return -5
	end	
	

	IF (@bonusamount > 0)
	BEGIN
		insert into [Users].[EventDetailLog]
			([UserID],[CreateTime],[GiftCash],[IPAddress],[LoginName],[EventSettingID],[EventType])
		values
			(@intUserID,@nowtime,@bonusamount,@chvIPAddress,@binding ,@eventSettingID,@eventType)

		if (@@rowcount <> 1)
		begin
			set @chvRtnMsg = '新增活动纪录失败'
			return -6
		end

		exec [dbo].[PrPsWeb_UpdateUserCash]
			@intUserID			= @intUserID,		--用户ID
			@sintSourceType		= @sintSourceType,	--来源
			@lngUpdateAmount	= @bonusamount,		--更新数量
			@chvIPAddress		= @chvIPAddress,	--IP
			@chvMemo			= @chvMemo,			--说明
			@lngCurrentAmount	= @lngCurrentAmount			OUTPUT, --当前金币数
			@lngTaxAmount		= 0,				--税收
			@intAreaID			= @intAreaID,		--渠道
			@intPlatformID		= @intPlatformID	--平台

		IF (@flowAmount > 0)
		BEGIN
			--寫入稽核流水
			EXEC [dbo].[PrWeb_Money_FlowAmountLimit] 
					@intUserID = @intUserID,
					@sintType = 1, 
					@intAuditType = 0,
					@intAmount = @bonusamount,  --增加金額/充值金額
					@intAuditAmount = @flowAmount, --稽核流水
					@sintSoruceTypeID = @sintSourceType,
					@chvRtnMsg = @chvRtnMsg OUTPUT	--錯誤訊息
		END
	END

	select @LoginTimes = Sum([GrantTimes]) from [Users].[EventLog] with (nolock) where EventSettingID = @eventSettingID and [LoginName] = @binding
	set @lngCurrentAmount = @lngCurrentAmount + @bonusamount


	--此參數是output參數
	set @LoginTimes = isnull(@LoginTimes,0)

	set @chvRtnMsg = '发送完成'
	return 1
	------------------------------------------------------------------------------------

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Event_LoginBonus] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Event_LoginBonus] TO [xbuser]
    AS [dbo];

