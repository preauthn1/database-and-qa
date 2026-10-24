USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrPs_Event_GetLottery')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrPs_Event_GetLottery] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Mars
-- Create date: 2020/03/05
-- Description: 獎勵活動-抽獎
-- Changelog:
--	2020/03/09	Mars			修正EXECUTE 后的事务计数指示 BEGIN 和 COMMIT 语句的数目不匹配
-- =============================================
ALTER PROCEDURE [dbo].[PrPs_Event_GetLottery]
(
	@intUserID				INT,
	@intPlatformID			INT = NULL,
	@intEventID				INT,
	@intLotteryID			INT OUTPUT,
	@intLotteryRemaining	INT OUTPUT,
	@chvRtnMsg				VARCHAR(200) OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @NowTime DATETIME = getdate(),
			@intAreaID INT,
			@intEventType INT = 0,
			@dtEvnetStartTime DATETIME,
			@dtEventEndTime DATETIME,
			@chvAwardName VARCHAR(200) = '',
			@intAwardType INT = 0,
			@intAwardAmount INT = 0,
			@intTotalRate INT = 0,
			@intRoundNum INT = 0,
			@chvLoginName VARCHAR(50),
			@chvIPAddress VARCHAR(50),
			@chvUpdater VARCHAR(50) = 'System', 
			@sintSourceType INT = 16001,  --幸运轮盘活动彩金; BankSourceType
			@chvMailMemo VARCHAR(50),
			@chvMailContent VARCHAR(200) 
	
	SET @intLotteryID = 0;
	SET @intLotteryRemaining = 0;

	--取得玩家平台
	IF (@intPlatformID IS NULL OR @intAreaID IS NULL)
	BEGIN
		SELECT @intPlatformID = PlatformID, @intAreaID = AreaID FROM dbo.fn_GetPlatformInfoByUserID(@intUserID)
	END

	--取得活動
	SELECT @intEventType = EventType
			,@dtEvnetStartTime = StartTime
			,@dtEventEndTime = EndTIme
	FROM Users.EventSetting 
	WHERE Status = 1 
	AND PlatformID = @intPlatformID
	AND ID = @intEventID
	
	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @chvRtnMsg = '查无活动';
		RETURN -1
	END
	IF (@NowTime < @dtEvnetStartTime)
	BEGIN
		SET @chvRtnMsg = '活动未开始';
		RETURN -1
	END
	IF (@NowTime > @dtEventEndTime)
	BEGIN
		SET @chvRtnMsg = '活动已结束';
		RETURN -1
	END

	--取得獎項總機率(權重)
	SELECT @intTotalRate = SUM(AwardRate) 
	FROM Event.EventSettingAwardItem
	WHERE EventSettingID = @intEventID
	AND (AwardLimit - AwardUsed) > 0

	IF (ISNULL(@intTotalRate, 0) = 0)
	BEGIN
		SET @chvRtnMsg = '无奖项';
		RETURN -1
	END

	--取得獎項
	SELECT TOP 1 @intLotteryID = T.ID, @chvAwardName = T.AwardName, @intAwardType = T.AwardType, @intAwardAmount = (T.AwardAmount)
	FROM (
		SELECT ID, AwardName, AwardType, AwardAmount, AwardRate, ISNULL(SUM(AwardRate) OVER (ORDER BY Id),0) AS CumulatedAwardRate
		FROM Event.EventSettingAwardItem
		WHERE EventSettingID = @intEventID
		AND (AwardLimit - AwardUsed) > 0
	) AS T
	WHERE T.CumulatedAwardRate >= Round(RAND() * @intTotalRate, 0)
	ORDER BY T.Id
	
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	--更新獎項數量
	UPDATE Event.EventSettingAwardItem 
	SET AwardUsed = (AwardUsed + 1) 
	WHERE ID = @intLotteryID 
	AND (AwardLimit - AwardUsed) > 0

	IF (@@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		SET @chvRtnMsg = '取得奖项失败';
		RETURN -1
	END

	SELECT @chvLoginName = [LoginName], @chvIPAddress = LastLogonIPAddress 
	FROM [Users].[UserInfo] with (nolock) where userid = @intUserID

	--寫入EventLog
	IF EXISTS (SELECT * FROM Users.EventLog WHERE UserID = @intUserID AND EventSettingID = @intEventID)
	BEGIN
		UPDATE Users.EventLog
		SET Updater = @chvUpdater, UpdateTime = @NowTime, GrantTimes = (GrantTimes + 1)
		WHERE UserID = @intUserID 
		AND EventSettingID = @intEventID
	END
	ELSE
	BEGIN
		INSERT INTO Users.EventLog(EventSettingID, UserID, EventType, LoginName, Updater, UpdateTime, GrantTimes)
		VALUES (@intEventID, @intUserID, @intEventType, @chvLoginName, @chvUpdater, @NowTime, 1)
	END

	IF (@@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		SET @chvRtnMsg = '写入奖项失败';
		RETURN -1
	END

	--奖项细项
	INSERT INTO Users.EventDetailLog(EventSettingID, EventType, UserID, LoginName, CreateTime, GiftCash, IPAddress, GiftMemo)
	VALUES(@intEventID, @intEventType, @intUserID, @chvLoginName, @NowTime, @intAwardAmount, @chvIPAddress, @chvAwardName)
	
	IF (@@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		SET @chvRtnMsg = '写入奖项细项失败';
		RETURN -1
	END

	--獎金, 需寫入MoneyLog
	IF (@intAwardType = 1)
	BEGIN
		DECLARE @lngCurrentCashAmount BIGINT,
				@lngCurrentAmount BIGINT,
				@lngUpdateAmount BIGINT,
				@chvMemo VARCHAR(50) = '幸运轮盘活动彩金'
				
		--取得保險箱金額資訊
		SELECT @lngCurrentAmount = Amount FROM Money.Bank WHERE UserID = @intUserID	
		SET @lngUpdateAmount = @intAwardAmount
		SET @lngCurrentCashAmount = @lngCurrentAmount + @lngUpdateAmount

		--更新保險箱金額
		UPDATE Money.Bank SET Amount = @lngCurrentCashAmount WHERE UserID = @intUserID
		
		IF (@@ROWCOUNT = 0)
		BEGIN
			ROLLBACK TRAN
			SET @chvRtnMsg = '更新保险箱金额失败';
			RETURN -1
		END

		--更新banklog
		EXEC [LogDB].[dbo].[PrPs_AddBankLog]
		@intUserID = @intUserID,
		@intSourceTypeID = @sintSourceType, 
		@lngCashAmount = @lngCurrentCashAmount, --更新後銀行金額
		@lngCurrentAmount = @lngCurrentAmount,  --更新前銀行金額
		@lngUpdateAmount = @lngUpdateAmount,    --此次異動金額
		@chrIPAddress = @chvIPAddress,
		@chrMemo = @chvMemo,
		@dtCreateTime = @NowTime,
		@intAreaID = @intAreaID,
		@intPlatformID = @intPlatformID
		
		SET @chvMailContent = N'恭喜您获得' + @chvAwardName +'，彩金将直接发至保险库，祝您游玩愉快。'
	END
	ELSE 
	--獎項
	BEGIN
		SET @chvMailContent = N'恭喜您获得' + @chvAwardName +'，请联络客服为您发奖，祝您顺心愉快。'
	END
	COMMIT TRAN

	IF (@intAwardType <> 3)
	BEGIN
		--发送系统邮件
		SET @chvMailMemo = '恭喜您中奖!!!'

		EXEC dbo.PrPs_SendSysMail
					@intUserID, 
					@chvMailMemo,
					@chvMailContent,
					0,
					NULL
		SET @chvRtnMsg = '抽奖成功，您本次抽奖获得' + @chvAwardName
	END
	ELSE
	BEGIN
		SET @chvRtnMsg = @chvAwardName
	END

	--取得剩餘抽獎券數
	EXEC [dbo].[PrPs_Event_GetLotteryCount]
			@intUserID = @intUserID,
			@intPlatformID = @intPlatformID,
			@intEventID = @intEventID,
			@intLotteryCount = @intLotteryRemaining OUTPUT

	RETURN
END