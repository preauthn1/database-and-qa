USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrPs_Event_GetFirstBonusEventSetting')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrPs_Event_GetFirstBonusEventSetting] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO


/****** Object:  StoredProcedure [dbo].[PrPs_Event_GetFirstBonusEventSetting]    Script Date: 2020/2/18 上午 09:41:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marshall
-- Create date: 2019-11-25
-- Description:	取得首存活動的設定
-- =============================================
ALTER PROCEDURE [dbo].[PrPs_Event_GetFirstBonusEventSetting]
	
	@intUserID int,
	@userChargeAmount bigint, --請傳入乘以100的數字	
	@output_isEventExist	bit = 0				OUTPUT,			--活動是否存在
	@output_eventSettingID	int = 0				OUTPUT,			--活動settingID
	@output_BonusRate		decimal(18,2) = 0	OUTPUT,	--活動存款回饋比例% (e.g 0.1%)
	@output_BonusFlowRate	int = 0				OUTPUT,
	@output_MaxLimitValue	bigint = 0			OUTPUT

AS
BEGIN


DECLARE @eventType int = 51;  --首存優惠的type
DECLARE @platformID int;
DECLARE @bonusGroup int;


---查出此用戶的所屬平台
SELECT @platformID = PlatformID FROM [dbo].[Fn_GetPlatformInfoByUserID] (@intUserID)


---查出該平台所設置的活動編號
SELECT @output_eventSettingID = ID 
FROM [Users].[EventSetting] 
WHERE PlatformID = @platformID AND EventType = @eventType AND [Status] = 1 AND StartTime <= GETDATE() AND GETDATE() <= EndTime


IF(@output_eventSettingID = 0)
	BEGIN
	
		SET @output_isEventExist = 0;

	END
ELSE
	BEGIN

		SET @output_isEventExist = 1;
	END

	

--找出多個獎勵中，排序最高且第一個符合條件的BonusGroup
SELECT TOP 1 @bonusGroup = [BonusGroup] FROM [Event].[EventSettingRuleItem]
WHERE EventSettingID = @output_eventSettingID AND RuleType = 6001 AND @userChargeAmount >= RuleValue
ORDER BY [BonusGroup] 



--查出獎勵設置
SELECT TOP 1  
@output_BonusRate = [Value] , 
@output_BonusFlowRate = [FlowRate]  ,
@output_MaxLimitValue = [MaxAmountLimit]

FROM [Event].[EvnetSettingBonus]
WHERE EventSettingID = @output_eventSettingID AND [BonusGroup] = @bonusGroup


END




