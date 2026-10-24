
-- =============================================
-- Author:  Marshall
-- Create date: 2019-10-08
-- Description:	同步其它渠道_根據所選的渠道(多選)

-- 2019-10-16	Marshall	改成不同步areaConfig這欄位(改成在程式碼中另外處理)
-- 2019-10-23	Marshall	修正 ConvertPopupText 欄位沒有更新到的bug
-- 2019-10-24	Marshall	新增欄位flowAmount(兩個)
-- =============================================

CREATE procedure [dbo].[PrWeb_SyncAreaConfigNew]
@intAreaID				int,						--同步參考的渠道號
@SelectedAreaIDs		dbo.ListInt READONLY,		--同步到哪些渠道
@chvErrMsg	VARCHAR(50) OUTPUT		--返回消息

As
BEGIN

set xact_abort on
DECLARE @chvFAQ varchar(5000)
DECLARE @chvUpGradeMsg varchar(1000)
DECLARE @chvAnnMsg varchar(1000)
DECLARE @chvPayTips varchar(1000)
DECLARE @chvAreaConfig varchar(5000)
DECLARE @chvPayAmountConfig varchar(1000)
DECLARE @chvConvertPopupText varchar(256)
DECLARE @intDefaultMoney int = 0
DECLARE @intGiftMoney int=50
DECLARE @intGiftMoneyFlowLimit bigint=0
DECLARE @intDefaultMoneyFlowLimit bigint=0
DECLARE @intAnnMsgShow tinyint
DECLARE @intShowConvertLimit bigint
DECLARE @intShowAllGameLimit bigint
DECLARE @intShowVIPAgent bigint
DECLARE @intShowCS bigint
DECLARE @intShowConvertBindPhone tinyint
DECLARE @intShowAllGameBindPhone tinyint
DECLARE @intShowVIPAgentBindPhone tinyint
DECLARE @intShowCSBindPhone tinyint
DECLARE @intPlaytimeCS int
DECLARE @intPlaytimeConvert int
DECLARE @intPlaytimeVIPAgent int
DECLARE @intShopNameID tinyint
DECLARE @intAgentNameID tinyint
DECLARE @IsGameCategoryFilterVisible bit

--取得作為樣板之渠道 的設定、並存入變數中
select 

	@chvFAQ=FAQContent,
	@chvPayTips=PayTips,
	@chvUpGradeMsg=UpGradeMsg,
	@chvAnnMsg=AnnMsg,
	@intAnnMsgShow=AnnMsgShow,
	@chvAreaConfig=AreaConfig,
	@intDefaultMoney=DefaultMoney,
	@intGiftMoney=GiftMoney,
	@intShowConvertLimit=ShowConvertLimit,
	@intShowAllGameLimit=ShowAllGameLimit,
	@intShowVIPAgent=ShowVIPAgent,
	@intShowCS=ShowCS,
	@intShowConvertBindPhone =ShowConvertBindPhone,
	@intShowAllGameBindPhone=ShowAllGameBindPhone,
	@intShowVIPAgentBindPhone=ShowVIPAgentBindPhone, 
	@intShowCSBindPhone=ShowCSBindPhone,
	@intPlaytimeCS=PlaytimeCS,
	@intPlaytimeConvert=PlaytimeConvert,
	@intPlaytimeVIPAgent=PlaytimeVIPAgent,
	@intShopNameID=ShopNameID,
	@intAgentNameID=AgentNameID,
	@chvConvertPopupText=ConvertPopupText,
	@intGiftMoneyFlowLimit=GiftMoneyFlowLimit,
	@intDefaultMoneyFlowLimit=DefaultMoneyFlowLimit,
	@IsGameCategoryFilterVisible = IsGameCategoryFilterVisible

from Area.Area with (nolock) where AreaID=@intAreaID



IF @@ROWCOUNT=0
BEGIN
	set @chvErrMsg = '错误:同步参考的渠道号不存在'
	RETURN 
END


BEGIN TRAN

	--更新其它的渠道基本資料
	update area.Area set
	FAQContent=@chvFAQ,
	PayTips=@chvPayTips,
	UpGradeMsg=@chvUpGradeMsg,
	AnnMsg=@chvAnnMsg,
	AnnMsgShow=@intAnnMsgShow,
	DefaultMoney=@intDefaultMoney,
	GiftMoney=@intGiftMoney,
	ShowConvertLimit=@intShowConvertLimit,
	ShowAllGameLimit=@intShowAllGameLimit,
	ShowVIPAgent=@intShowVIPAgent,
	ShowCS=@intShowCS,
	ShowConvertBindPhone =@intShowConvertBindPhone,
	ShowAllGameBindPhone=@intShowAllGameBindPhone,
	ShowVIPAgentBindPhone=@intShowVIPAgentBindPhone, 
	ShowCSBindPhone=@intShowCSBindPhone,
	PlaytimeCS=@intPlaytimeCS,
	PlaytimeConvert=@intPlaytimeConvert,
	PlaytimeVIPAgent=@intPlaytimeVIPAgent,
	ShopNameID=@intShopNameID,
	AgentNameID=@intAgentNameID,
	ConvertPopupText = @chvConvertPopupText,
	GiftMoneyFlowLimit = @intGiftMoneyFlowLimit,
	DefaultMoneyFlowLimit = @intDefaultMoneyFlowLimit,
	IsGameCategoryFilterVisible = @IsGameCategoryFilterVisible

	where AreaID in (SELECT [Value] FROM @SelectedAreaIDs) and AreaID <> @intAreaID

	
	DECLARE @intCurAreaID int
	DECLARE @chvNewAreaConfig varchar(5000)

	DECLARE areaCursor CURSOR FOR
	select AreaID from area.Area with (nolock) 
	where AreaID in (SELECT [Value] FROM @SelectedAreaIDs) and AreaID <> @intAreaID


	OPEN areaCursor
	FETCH NEXT FROM areaCursor INTO @intCurAreaID

	WHILE @@FETCH_STATUS = 0
	BEGIN		

		--刪除渠道的原先遊戲清單
		delete Area.GameList where AreaID = @intCurAreaID
		
		--新增渠道遊戲清單
		insert Area.GameList(platformid,areaid,gameid,sort,[status],IconID,Popular)
		select PlatformID, @intCurAreaID as AreaID, GameID, Sort, Status,IconID,Popular from Area.GameList where AreaID=@intAreaID


		--删除渠道的原先广告
		delete Area.Advertisement where AreaID = @intCurAreaID

		--新增渠道广告清單
		insert Area.Advertisement(platformid,areaid,Picture,Link,Behavior,Status,CreateTime)
		select PlatformID, @intCurAreaID as AreaID,Picture,link,Behavior,Status, getdate() as CreateTime from Area.Advertisement where AreaID=@intAreaID

	FETCH NEXT FROM areaCursor INTO @intCurAreaID
	END

	CLOSE areaCursor
	DEALLOCATE areaCursor


COMMIT TRAN

SET @chvErrMsg = '同步渠道設定成功'
RETURN 1

END