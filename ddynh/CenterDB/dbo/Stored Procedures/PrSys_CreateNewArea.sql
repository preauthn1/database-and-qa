-- =============================================
-- Description:	建立新渠道
-- =============================================
CREATE procedure [dbo].[PrSys_CreateNewArea]
@intPlatformid int,
@intBaseAreaID int,
@intBegin int,
@intEnd int

As
BEGIN

set xact_abort on

--渠道號
DECLARE @intAreaID int
--渠道名稱
DECLARE @chvAreaName varchar(50)
--平台號字串
DECLARE @chvPlatformid varchar(32)
SET @chvPlatformid = CONVERT(varchar,@intPlatformid)
--平台名稱
DECLARE @chvPlatformName varchar(32)


Select @chvPlatformName=Name from Area.Platform where PlatformID = @intPlatformid
IF @@ROWCOUNT=0
BEGIN
	PRINT 'Area.Platform 平台號不存在'
	RETURN 
END


BEGIN TRAN


	--新增渠道
	DECLARE @chvNum varchar(5)
	DECLARE @chvClientType varchar(20)=''
	DECLARE @chvClientName varchar(20)=''
	DECLARE @intNum int = @intBegin
	WHILE @intNum <= @intEnd
	BEGIN
		
		
		SET @chvNum= RIGHT(REPLICATE('0', 3) + CAST(@intNum as VARCHAR), 3)

		IF @intNum = 0 BEGIN SET @chvClientType='IOS'; SET @chvClientName='苹果' END
		IF @intNum > 0 BEGIN SET @chvClientType='Android'; SET @chvClientName='安卓' END
		
	 
		SET @chvAreaName = @chvPlatformName + @chvClientName + @chvNum; 
		SET @intAreaID = Convert(int,@chvPlatformid + @chvNum);
		
		IF EXISTS(SELECT 1 FROM [Area].[Area] WHERE AreaID=@intAreaID) 
		BEGIN  
			PRINT 'Area.Area渠道號重複'
			ROLLBACK TRAN
			RETURN
		END
		
		--新增渠道
		Insert into [CenterDB].[Area].[Area] (areaid,areaname,ClientPlatform,PlatformID,[Memo],[AdminID],[Sort],[ShareURL],FAQContent,PayTips,UpGradeMsg,AnnMsg,AnnMsgShow,SetDefault,AreaConfig,DefaultMoney,GiftMoney) 
		Select @intAreaID as AreaID,@chvAreaName as AreaName, @chvClientType as ClientPlatform, @intPlatformid as PlatformID,@chvAreaName as Memo,1 as AdminID,Sort,'' as ShareURL,
		FAQContent,PayTips,UpGradeMsg,AnnMsg,AnnMsgShow,0 as SetDefault, AreaConfig,
		DefaultMoney,
		GiftMoney
		From [CenterDB].[Area].[Area] where PlatformID = @intPlatformid and AreaID=@intBaseAreaID
		
		--新增渠道的遊戲清單
		insert Area.GameList(platformid,areaid,gameid,sort,[status],IconID)
		Select @intPlatformid as PlatformID, @intAreaID as areaID, gameid, sort, [status],IconID from area.GameList where  PlatformID = @intPlatformid and AreaID=@intBaseAreaID

		--新增渠道管理者
		--insert into area.AreaAdminUser(AdminID,AreaID,PlatformID)
		--select u.UserID as AdminID, @intAreaID as AreaID,@intPlatformid as PlatformID from AdminSys.Admin.users u
		--where u.UserType <> 10

		--渠道代理配置
		insert [Club02].[dbo].[AgentModeConfig] ([PlatformID],[AreaID],[Mode1],[Mode2],[Mode3],[Mode4],[Mode5],[Mode6])
		Select [PlatformID],@intAreaID,[Mode1],[Mode2],[Mode3],[Mode4],[Mode5],[Mode6] from [Club02].[dbo].[AgentModeConfig] where PlatformID = @intPlatformid and AreaID=@intBaseAreaID

		--渠道代理域名配置
		insert [Club02].[dbo].[DomainSetting] ([PlatformID],[AreaID],[Domain],[Status],[CreateTime],[PlatformName])
		SELECT [PlatformID],@intAreaID,[Domain],[Status],getdate(),[PlatformName] FROM [Club02].[dbo].[DomainSetting] where PlatformID = @intPlatformid and AreaID=@intBaseAreaID

		SET @intNum = @intNum + 1
	END
	


COMMIT TRAN
RETURN 1

END