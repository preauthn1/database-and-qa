-- =============================================
-- Author:  Jason
-- Create date: 2018/08/01
-- Description:	GS活動資料查詢


--	2019/11/21		Marshall		資料表結構大改
--	2019/11/25		Marshall		ISNULL防呆
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Event_LoginBonusCheck]
(
	@intUserID	INT,
	@LoginTimes	INT = 0				OUTPUT,
	@GiftCash		BIGINT = 0		OUTPUT,
	@chvRtnMsg	VARCHAR(100) = ''	OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	declare @nowtime datetime = getdate()
	declare @chargeamount bigint
	declare @binding varchar(32)
	declare @intAreaID int
	declare @platformID int
	declare @eventSettingID int = 0;
	
	SET @platformID = (SELECT PlatformID FROM Fn_GetPlatformInfoByUserID (@intUserID))
	SET @eventSettingID = (SELECT top 1 ID FROM [Users].[EventSetting] with (nolock) where EventType = 1 AND PlatformID = @platformID AND [Status] = 1)

	select @chargeamount = (sumcharge+SumAgentCharge), @binding = [LoginName],@intAreaID = [AreaID] from [Users].[UserInfo] with (nolock) where userid = @intUserID
	select @LoginTimes = Sum([GrantTimes]) from [Users].[EventLog] with (nolock) where EventSettingID = @eventSettingID and [LoginName] = @binding
	select @giftcash = ISNULL((select top 1 RuleValue from [Event].[EventSettingRuleItem] where EventSettingID = @eventSettingID AND RuleType = 2001) , 0)

	set @LoginTimes = isnull(@LoginTimes,0)
	set @chargeamount = isnull(@chargeamount,0)

	if not exists (select top 1 1 from [Users].[EventSetting] with (nolock) where [Status] = 1 and starttime <= @nowtime and endtime > @nowtime and Id = @eventSettingID)
	begin
		set @chvRtnMsg = '活动不存在'
		return -1
	end

	if (@LoginTimes >= 7)
	begin
		set @chvRtnMsg = '已领超过七次限制'
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

	if exists (select top 1 1 from [Users].[EventLog] with (nolock) where EventSettingID = @eventSettingID and [LoginName] = @binding and datediff(day,[UpdateTime],@nowtime) = 0)
	begin
		set @chvRtnMsg = '今日已领过奖励'
		return 0
	end

	if not exists (select top 1 1 from [Users].[EventLog] with (nolock) where EventSettingID = @eventSettingID and [LoginName] = @binding and datediff(day,[UpdateTime],@nowtime) = 0)
	begin
		set @chvRtnMsg = '今日尚未领过奖励'
		return 1
	end
	

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Event_LoginBonusCheck] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Event_LoginBonusCheck] TO [xbuser]
    AS [dbo];

