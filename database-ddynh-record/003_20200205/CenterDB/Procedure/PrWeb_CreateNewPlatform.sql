USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_CreateNewPlatform')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_CreateNewPlatform] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  alan
-- Create date: 20180719
-- Description:	建立新平台
-- 	2019/06/10 	Jason 		因更新誤蓋檔問題補回若為聯運平台則club新增客服聯絡資訊
-- 	2019/06/18 	CCC 		新增代理後台域名預設值
-- 	2019/09/05 	Mars 		更新新增平台的內容文字
-- 	2019/10/30 	Mars 		修改新增版本時, 將大廳版本寫至新表hallversions
-- 	2019/11/21 	Mars 		新增版本時, 增加各平台的兌換設置
-- 	2020/03/27 	Mars 		刪除 預設新增渠道管理者 / 預設新增平台管理者配置
-- =============================================
ALTER procedure [dbo].[PrWeb_CreateNewPlatform]
	@intPlatformID int,					--指定平台號
	@chvPlatformName varchar(32),		--平台名稱
	@intCompany tinyint, 				--营运平台
	@intAreaNum int=10, 				--預設建立渠道数量
	@chvErrMsg	VARCHAR(50) OUTPUT		--返回消息
As
BEGIN

set xact_abort on

--渠道號
DECLARE @intAreaID int
--渠道名稱
DECLARE @chvAreaName varchar(32)
--平台號字串
DECLARE @chvPlatformid varchar(32)
SET @chvPlatformid = CONVERT(varchar,@intPlatformID)


IF @intAreaNum > 200
BEGIN
	SET @chvErrMsg = '错误:預設建立渠道数量不能超过200个'
	RETURN -1
END


IF EXISTS(SELECT 1 FROM [CenterDB].[ServerInfo].[HallVersion] WITH (NOLOCK) WHERE AndroidVersion like '%,'+@chvPlatformid+'_%' OR IOSVersion like '%,'+@chvPlatformid+'_%')
BEGIN
	SET @chvErrMsg = '错误:平台版本号重複'
	RETURN -1
END


IF EXISTS(Select 1 from Area.Platform  WITH (NOLOCK) where PlatformID = @intPlatformID)
BEGIN
	SET @chvErrMsg = '错误:平台编号重複'
	RETURN -1 
END


IF EXISTS(Select 1 from Area.GameList  WITH (NOLOCK) where PlatformID = @intPlatformID)
BEGIN
	SET @chvErrMsg = '错误:平台游戏清单重複'
	RETURN -1 
END

IF EXISTS(Select 1 from Area.PlatformAdminUser  WITH (NOLOCK) where PlatformID = @intPlatformID)
BEGIN
	SET @chvErrMsg = '错误:平台管理者配置重複'
	RETURN -1 
END


IF EXISTS(Select 1 from Area.Advertisement  WITH (NOLOCK) where PlatformID = @intPlatformID)
BEGIN
	SET @chvErrMsg = '错误:平台广告配置重複'
	RETURN -1 
END

IF EXISTS(Select 1 from Area.Area where PlatformID = @intPlatformid)
BEGIN
	PRINT '错误:Area.Area平台號重複'
	RETURN 
END


DECLARE @chvFAQ varchar(5000)
DECLARE @chvUpGradeMsg varchar(1000)
DECLARE @chvAnnMsg varchar(1000)
DECLARE @chvPayTips varchar(1000)
DECLARE @chvAreaConfig varchar(5000)
DECLARE @chvPayAmountConfig varchar(1000)
DECLARE @intDefaultMoney int = 0
DECLARE @intGiftMoney int=50

SET @chvFAQ = 
'<color=#EEC900><size=35>Q:金币说明</size></color>

<color=#FFFFFF><size=30>A:金币是游戏内进行游戏时使用的货币，可以通过充值或活动取得，充值与金币的比例为1：1。</size></color>

<color=#EEC900><size=35>Q:帐号登入</size></color>

<color=#FFFFFF><size=30>A:游戏使用手机号进行帐号的注册与登入。点击设置后，再点击切换帐号可以返回到登入介面进行登入。</size></color>

<color=#EEC900><size=35>Q:短信验证</size></color>

<color=#FFFFFF><size=30>A:请勿频繁验证短信验证码，如果收不到验证码，请稍等五分钟后再进行验证。若仍有疑问可联系客服询问。</size></color>

<color=#EEC900><size=35>Q:忘记密码</size></color>

<color=#FFFFFF><size=30>A:忘记密码请使用手机号码重新设置。在登入介面点击忘记密码，重新取得验证码进行密码重置。</size></color>

<color=#EEC900><size=35>Q:联系客服</size></color>

<color=#FFFFFF><size=30>A:如果遇到任何游戏内的问题，请及时联系客服以寻求帮助，我们会竭诚为您服务。</size></color>'

SET @chvUpGradeMsg = '绑定成功！如有任何问题请联系客服。'
SET @chvAnnMsg = '欢迎游玩本游戏平台，如有任何疑问请联系客服。'
SET @chvPayTips = '1.充值比例：1元=1.00金币。  2.每筆最低充值金额为10元。  3.支付宝或者微信需安装客户端。  4.VIP或代理充值为官方认证的充值方式，请安心使用。'
SET @chvPayAmountConfig = '1:+100.+300.+500.+1000.+2000|2:+100.+200.+300.+400.+500|3:+100.+200.+300.+400.+500|4:+100.+200.+300.+400.+500'

BEGIN TRAN

	--新增平台
	INSERT INTO [CenterDB].[Area].[Platform]
				([PlatformID],[Name],[UpGradeMsg],[AnnMsg],[FAQContent],[PaySort],[UIFlag],[PayTip],[PayAmountConfig],[PayStatus],[PayCloseTip],
				ShanFuAccountID,ShanFuSign,ShanFuPayAgentUrl,ShanFuPayAgentClientUrl,Company)
	SELECT 
	@intPlatformid as [PlatformID], 
	@chvPlatformName as [Name],
	@chvUpGradeMsg as [UpGradeMsg],
	@chvAnnMsg as [AnnMsg],
	@chvFAQ as [FAQContent],
	'1,2,3,4' as [PaySort],
	'0110' as [UIFlag],
	@chvPayTips as [PayTip],
	@chvPayAmountConfig as [PayAmountConfig],
	1 as [PayStatus],
	'充值关闭' as [PayCloseTip],
	'10020' as ShanFuAccountID,
	'a343a2a5cabca3a6622fbd637d964e9a' as ShanFuSign,
	'http://example.invalid' as ShanFuPayAgentUrl,
	'http://example.invalid/index/login/auto_login' as ShanFuPayAgentClientUrl,
	@intCompany


	--新增渠道
	DECLARE @chvNum varchar(3)
	DECLARE @chvClientType varchar(20)=''
	DECLARE @chvClientName varchar(20)=''


	DECLARE @intNum int = 0
	WHILE @intNum <= @intAreaNum
	BEGIN
		SET @chvNum= RIGHT(REPLICATE('0', 3) + CAST(@intNum as VARCHAR), 3)

		IF @intNum = 0 BEGIN SET @chvClientType='IOS'; SET @chvClientName='苹果' END
		IF @intNum > 0 BEGIN SET @chvClientType='Android'; SET @chvClientName='安卓' END
		 
	 
		SET @chvAreaName = @chvPlatformName + @chvClientName + @chvNum; 
		SET @intAreaID = Convert(int,@chvPlatformid + @chvNum);

		

		IF EXISTS(SELECT 1 FROM [Area].[Area] WHERE AreaID=@intAreaID) 
		BEGIN  
			print @intAreaID
			PRINT '错误:Area.Area渠道號重複'
			ROLLBACK TRAN
			RETURN
		END

		SET @chvAreaConfig = 
		'{"systemConfig":{"Info":{"ShowCaiJinchi":0,"BundleID":"","AppName":"' + @chvPlatformName + 
		'","AppleID":"","ServerOption":0,"PlatformID":' + convert(varchar,@intPlatformID) + 
		',"SiteID":' + convert(varchar,@intAreaId) + 
		',"StaticSiteID":0,"Agent":0,"Template":"UI_6","FlagExchage":0,"ExchangeFontType":0},' + 
		'"JiuLiao":{"JiuLiaoId":"","JiuLiaoSecrety":"","JiuLiaoName":"","DownloadUrl":""},' + 
		'"payConfig":{"UIFlagPay":true,"UIFlagAgent":true,"UIFlagApplyAgent":false,"UIFlagJiuLiao":false,"UIFlagShanFu":false,"UIClub2AgentMode1":false,"UIClub2AgentMode2":false,"UIClub2AgentMode3":true,"UIClub2AgentMode4":false,"UIClub2AgentMode5":false,"UIClub2AgentMode6":false}}}'

		--新增渠道
		Insert into [CenterDB].[Area].[Area] (AreaID,AreaName,ClientPlatform,PlatformID,[Memo],[AdminID],[Sort],FAQContent,PayTips,UpGradeMsg,AnnMsg,AnnMsgShow,SetDefault,AreaConfig,DefaultMoney,GiftMoney,ShopNameID,AgentNameID,ShareURL,ShowConvertLimit,ShowAllGameLimit,ShowVIPAgent,ShowCS,ShowConvertBindPhone,ShowAllGameBindPhone,ShowVIPAgentBindPhone,ShowCSBindPhone,PlaytimeCS,PlaytimeConvert,PlaytimeVIPAgent,CreateTime,AreaStatus) 
		values (@intAreaID ,@chvAreaName, @chvClientType, @intPlatformid, @chvAreaName, 1, 10, @chvFAQ, @chvPayTips, @chvUpGradeMsg, @chvAnnMsg, 0, 0, @chvAreaConfig, @intDefaultMoney,@intGiftMoney,1,1,'',0,0,0,0,0,0,0,0,0,0,0,getdate(),1)
		
		
		--新增渠道的遊戲清單
		insert Area.GameList(platformid,areaid,gameid,sort,[status],IconID)
		select 
		@intPlatformID as PlatformID, @intAreaID as AreaID, G.GameID, 99 as Sort, 1 as Status,
		MIN(A.IconID) as IconID from ServerInfo.GameList G left join area.GameAliasName A on G.GameID=A.GameID
		WHERE G.Status=1
		GROUP BY G.GameID
		
		--新增代理後台域名
		insert into [Club02].[dbo].[DomainSetting] (PlatformID, AreaID, Domain, [Status], CreateTime, PlatformName)
		values (@intPlatformid, @intAreaID, 'https://example.invalid/', 1, getdate(), @chvPlatformName)

		SET @intNum = @intNum + 1
	END

	--檢查平台版本是否重複
	declare @chvAndroidVersion nvarchar(max), @chvIOSVersion nvarchar(max),@chvAndroidVersion2 nvarchar(max), @chvIOSVersion2 nvarchar(max)

	SELECT platformid
	FROM serverinfo.HallVersions WITH (NOLOCK)
	WHERE platformid = @intPlatformID

	IF (@@ROWCOUNT > 0)
	BEGIN
		PRINT '错误:HallVersion平台版本重複'
		ROLLBACK TRAN
		RETURN
	END

	--修改Hallversion资料, 增加平台版本号
	--临时版本号
	INSERT INTO ServerInfo.HallVersions(PlatformID, HallSkinID, AndroidVersion, IOSVersion, [Type])
	SELECT @intPlatformID as PlatformID, A.HallSkinID, '1.0.0' as AndroidVersion, '1.0.0' as IOSVersion, 1 as [Type]
	FROM ServerInfo.HallSkin as A
	WHERE NOT EXISTS (
		SELECT * 
		FROM ServerInfo.HallVersions as B 
		WHERE B.PlatformID = @intPlatformID AND B.Type = 1 AND A.HallSkinID = B.HallSkinID 
	)
	--真实版本号
	INSERT INTO ServerInfo.HallVersions(PlatformID, HallSkinID, AndroidVersion, IOSVersion, [Type])
	SELECT @intPlatformID as PlatformID, A.HallSkinID, '1.0.0' as AndroidVersion, '1.0.0' as IOSVersion, 2 as [Type]
	FROM ServerInfo.HallSkin as A
	WHERE NOT EXISTS (
		SELECT * 
		FROM ServerInfo.HallVersions as B 
		WHERE B.PlatformID = @intPlatformID AND B.Type = 2 AND A.HallSkinID = B.HallSkinID 
	)

	--新增渠道包下載資訊
	--Correct : 是否正確 1正確 0不正確
	--IOSTerminate : IOS是否下架 1 已經下架 0上架
	INSERT INTO [Area].[PlatformDownload] (PlatformID, IOS, Android, Official, IOSTerminate, IOSMemo, Correct, Memo)
	VALUES(@intPlatformID,'','','',0,'',0,'')
	
	--新增各平台兌換設置
	IF (NOT EXISTS(SELECT 1 FROM ServerInfo.SystemConfig WHERE PlatformID = @intPlatformID))
	BEGIN
		INSERT INTO ServerInfo.SystemConfig
		SELECT TOP 1 @intPlatformID as PlatformID
		      ,[ConvertStatus]
		      ,[PromptMsg]
		      ,[AutoCheckLimit]
		      ,[ConvertRetainAmount]
		      ,[ConvertMinAmount]
		      ,[ConvertMaxAmount]
		      ,[ConvertRateTip]
		      ,[BankDefaultPwdTip]
		      ,[QuestionContactTip]
		      ,[ConvertBankShow]
		      ,[ConvertAlipayShow]
		      ,[ConvertWinLostAlert]
		      ,[TGBotToken]
		      ,[TGChatID]
		  FROM ServerInfo.SystemConfig
		  WHERE PlatformID = 0
	END

	--如果是聯運平台,塞入聯運表
	IF (@intCompany <> 1) AND not exists(select 1 from  area.UnionPlatform where PlatformID=@intPlatformID)
	BEGIN
		INSERT INTO area.UnionPlatform(PlatformID) VALUES(@intPlatformID)
	END
	
	--非聯運平台, 新增全民代理客服清单
	DECLARE @intUnionPlatform INT
	IF EXISTS (SELECT TOP 1 1 FROM Area.UnionPlatform WHERE PlatformID = @intPlatformID)
	BEGIN
		SET @intUnionPlatform = 1
	END
	ELSE
	BEGIN
		SET @intUnionPlatform = 0
	END

	if (@intUnionPlatform = 0)  AND not exists(select 1 from Club.dbo.OfficialUserConfig with (nolock) where PlatformID=@intPlatformID)
	begin
		insert into  Club.dbo.OfficialUserConfig (PlatformID,OfficialUser1,OfficialUser2,OfficialUser3)
		values(@intPlatformID,'481329270','481329270','481329270')
	end

COMMIT TRAN

SET @chvErrMsg = '新增平台成功'
RETURN 1

END