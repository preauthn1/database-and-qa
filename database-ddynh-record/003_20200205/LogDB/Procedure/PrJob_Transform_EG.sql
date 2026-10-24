USE [LogDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_Transform_EG')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_Transform_EG] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Louis
-- Create date: 2020/03/10
-- Description:	E-Gaming 資料轉換 EGamingBetRecord -> GameLog, PerGameLog, DetailLog
-- 2020/03/16	Louis	PerGameLog.GameData增加來源GameType，各玩家BetTarget
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_Transform_EG]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @GameMerchantCode NVARCHAR(20) = 'EG'
	DECLARE @GameID INT = 777031
	DECLARE @ServerID INT = (SELECT TOP 1 [ServerID] FROM [CenterDB].[ServerInfo].[GameServerList] WHERE [GameID] = @GameID)
	DECLARE @TableName NVARCHAR(50) = 'GameLog'
	DECLARE @JobID INT = NULL
	DECLARE @LastRecordID BIGINT = 0
	DECLARE @StartRecordID BIGINT = 0
	DECLARE @EndRecordID BIGINT = 0
	SET @ServerID = ISNULL(@ServerID,@GameID)
	/*-----處理[LogDB].[Game].[GameLog]-----*/
	--取得上次最後處理的紀錄編號(有成功的排程)
	SELECT TOP 1 @LastRecordID = [EndRecordID] FROM [LogDB].[ThirdParty].[TransformJobRecord]
	WHERE [GameMerchantCode] = @GameMerchantCode AND [GameID] = @GameID AND [ServerID] = @ServerID 
	AND [Status] = 1 AND [TableName] = @TableName
	ORDER BY ID DESC 
	SET @LastRecordID = ISNULL(@LastRecordID,0)
	--取得本次排程要處理的起訖紀錄編號
	SELECT @EndRecordID = MAX(ID),@StartRecordID = MIN(ID) 
	FROM [LogDB].[ThirdParty].[EGamingBetRecord] WHERE [ID] > @LastRecordID

	--確認本次是否有需要處理的資料
	IF ISNULL(@EndRecordID,0) > 0 AND ISNULL(@StartRecordID,0) > 0
	BEGIN
		--先記錄一筆排程紀錄，取得流水編號
		INSERT INTO [LogDB].[ThirdParty].[TransformJobRecord]([GameMerchantCode],[GameID],[ServerID],[TableName],[Status],[StartRecordID],[EndRecordID],[CreateTime],[UpdateTime])
		VALUES(@GameMerchantCode,@GameID,ISNULL(@ServerID,0),@TableName,0,@StartRecordID,@EndRecordID,GETDATE(),GETDATE())

		SET @JobID = @@IDENTITY

		--先將資料存放到暫存表中
		DECLARE @GameLog_temp TABLE
		(
			[PlatformID] INT,[UserID] INT,[AreaID] INT,[Amount] BIGINT,[FlowAmount] BIGINT,[WinCount] INT,[LoseCount] INT,[DrawCount] INT
			,[UserIPAddress] VARCHAR(15),[LoginTime] DATETIME,[BetAmount] BIGINT,[PayAmount] BIGINT
		)
		INSERT INTO @GameLog_temp([PlatformID],[UserID],[AreaID],[Amount],[FlowAmount],[WinCount],[LoseCount],[DrawCount]
		,[UserIPAddress],[LoginTime],[BetAmount],[PayAmount])
		SELECT [PlatformID] AS [PlatformID]
		,[UserID] AS [UserID]
		,(SELECT [AreaID] FROM [CenterDB].[Users].[UserInfo] WITH(NOLOCK) WHERE [UserID] = E.[UserID]) AS [AreaID]
		,SUM([WinLossAmount]) AS [Amount]
		,SUM(ABS([WinLossAmount])) AS [FlowAmount]
		,SUM(CASE WHEN [WinLossAmount] > 0 THEN 1 ELSE 0 END) AS [WinCount]
		,SUM(CASE WHEN [WinLossAmount] < 0 THEN 1 ELSE 0 END) AS [LoseCount]
		,SUM(CASE WHEN [WinLossAmount] = 0 THEN 1 ELSE 0 END) AS [DrawCount]
		,[UserIPAddress] AS [IPAddress]
		,DATEADD(HH,8,MIN([StartBetTimeUTC])) AS [LoginTime]
		,SUM([BetAmount]) AS [BetAmount]
		,SUM([PayoutAmount]) AS [PayAmount]
		FROM [LogDB].[ThirdParty].[EGamingBetRecord] AS E
		WHERE [ID] >= @StartRecordID AND [ID] <= @EndRecordID
		GROUP BY [PlatformID],[UserID],[UserIPAddress]

		--新增[LogDB].[Game].[GameLog]
		INSERT INTO [LogDB].[Game].[GameLog]([PlatformID],[AreaID],[GameID],[ServerID],[UserID],[TradeID]
		,[LoginMoney],[Amount],[TaxAmount],[FlowAmount],[WinCount],[LoseCount],[DrawCount],[GameTime]
		,[IPAddress],[HDCode],[HDType],[LoginTime],[LogoutTime],[BetAmount],[PayAmount])
		SELECT [PlatformID],[AreaID],@GameID AS [GameID],@ServerID AS [ServerID],[UserID],ISNULL(@JobID,0) AS [TradeID]
		,0 AS [LoginMoney],[Amount],0 AS [TaxAmount],[FlowAmount],[WinCount],[LoseCount],[DrawCount],0 AS [GameTime]
		,[UserIPAddress],'000000' AS [HDCode],1 AS [HDType],[LoginTime],GETDATE() AS [LogoutTime],[BetAmount],[PayAmount]
		FROM @GameLog_temp

		--更新[Stat].[StatisticsUserAmount_Day]
		MERGE [Stat].[StatisticsUserAmount_Day] AS A
		USING 
		(
			SELECT [UserID],[PlatformID],[AreaID]
			,SUM([Amount]) AS [Amount],SUM([FlowAmount]) AS [FlowAmount] ,CONVERT(DATE,GETDATE()) AS [LogDate],COUNT(1) AS [GameCount]
			FROM @GameLog_temp
			GROUP BY [UserID],[PlatformID],[AreaID]
		) AS B ON A.[UserID] = B.[UserID] AND A.[LogDate] = B.[LogDate] AND A.[PlatformID] = B.[PlatformID] AND A.[AreaID] = B.[AreaID]
		WHEN MATCHED THEN
			UPDATE SET 
				[FlowAmount] = A.[FlowAmount] + B.[FlowAmount]
				,[FlowCount] = A.[FlowCount] + B.[GameCount]
				,[GameAmount] = A.[GameAmount] + B.[Amount]
				,[GameAmountCount] = A.[GameAmountCount] + B.[GameCount] 
		WHEN NOT MATCHED THEN
			INSERT ([LogDate],[UserID],[PlatformID],[AreaID],[ChargeAmount],[ConvertAmount],[FlowAmount],[GameTaxAmount],[ConvertTaxAmount]
			,[ChargeCount],[ConvertCount],[FlowCount],[GameTaxCount],[ConvertTaxCount],[GameAmount],[GameAmountCount])
			VALUES (B.[LogDate],B.[UserID],B.[PlatformID],B.[AreaID],0,0,B.[FlowAmount],0,0
			,0,0,B.[GameCount],0,0,B.[Amount],B.[GameCount]);

		--更新排程紀錄
		UPDATE [LogDB].[ThirdParty].[TransformJobRecord]
		SET [Status] = 1, [UpdateTime] = GETDATE()
		WHERE [ID] = @JobID

	END


	/*-----處理[PerGameLog].[PerLog].[PerGameLog]-----*/
	SET @TableName = 'PerGameLog'
	--取得上次最後處理的紀錄編號(有成功的排程)
	SELECT TOP 1 @LastRecordID = [EndRecordID] FROM [LogDB].[ThirdParty].[TransformJobRecord]
	WHERE [GameMerchantCode] = @GameMerchantCode AND [GameID] = @GameID AND [ServerID] = @ServerID 
	AND [Status] = 1 AND [TableName] = @TableName
	ORDER BY ID DESC 
	SET @LastRecordID = ISNULL(@LastRecordID,0)
	--取得本次排程要處理的起訖紀錄編號
	SELECT @EndRecordID = MAX(ID),@StartRecordID = MIN(ID) 
	FROM [LogDB].[ThirdParty].[EGamingBetRecord] WHERE [ID] > @LastRecordID


	--確認本次是否有需要處理的資料
	IF ISNULL(@EndRecordID,0) > 0 AND ISNULL(@StartRecordID,0) > 0
	BEGIN
		--先記錄一筆排程紀錄，取得流水編號
		INSERT INTO [LogDB].[ThirdParty].[TransformJobRecord]([GameMerchantCode],[GameID],[ServerID],[TableName],[Status],[StartRecordID],[EndRecordID],[CreateTime],[UpdateTime])
		VALUES(@GameMerchantCode,@GameID,ISNULL(@ServerID,0),@TableName,0,@StartRecordID,@EndRecordID,GETDATE(),GETDATE())

		SET @JobID = @@IDENTITY

		DECLARE @RoundList TABLE([LogID] BIGINT,[GameData] NVARCHAR(MAX),[GameTime] DATETIME,[DAYS] INT,[RoundID] NVARCHAR(50))

		DECLARE @DetailLog_temp TABLE(UserID BIGINT, RoundID NVARCHAR(50),Amount BIGINT,StartTime DATETIME,EndTime DATETIME
		, GameType NVARCHAR(20),BetTarget NVARCHAR(MAX))
		INSERT INTO @DetailLog_temp([UserID],[RoundID],[Amount],[StartTime],[EndTime],[GameType],[BetTarget])
		SELECT [UserID],[RoundID]
		,SUM([WinLossAmount]) AS [Amount]
		,DATEADD(HH,8,CONVERT(DATETIME,CONVERT(VARCHAR,MIN([StartBetTimeUTC]),120))) AS [StartTime]
		,DATEADD(HH,8,CONVERT(DATETIME,CONVERT(VARCHAR,MAX([PayoutTimeUTC]),120))) AS [EndTime]
		,MAX([GameType]) AS [GameType]
		,STUFF((SELECT  ',' + [BetTarget] FROM [LogDB].[ThirdParty].[EGamingBetRecord] WITH(NOLOCK) WHERE [RoundID] = E.[RoundID] FOR XML PATH('')),1,1,'') as [BetTarget]
		FROM [LogDB].[ThirdParty].[EGamingBetRecord] AS E WITH(NOLOCK)
		WHERE [ID] >= @StartRecordID AND [ID] <= @EndRecordID
		GROUP BY [UserID],[RoundID]

		INSERT INTO [PerGameLog].[PerLog].[PerGameLog]([GameID],[ServerID],[GameData],[TaxAmount],[BeginTime],[EndTime],[days])
		OUTPUT inserted.[Id],inserted.[GameData],inserted.[EndTime],inserted.[days]
		INTO @RoundList([LogID],[GameData],[GameTime],[DAYS])
		SELECT @GameID,@ServerID,'RoundID=' + [RoundID] + ';GameType=' + MAX([GameType]) + ';'
		+ STUFF((SELECT  ';UserID=' + CONVERT(NVARCHAR,[UserID]) + ',BetTarget=' + [BetTarget] 
		FROM @DetailLog_temp WHERE [RoundID] = A.[RoundID] FOR XML PATH('')),1,1,'') as [BetTarget]
		,0,MIN([StartTime]),MAX([EndTime])
		,DATEDIFF(MINUTE,0,MAX([EndTime])) + CASE WHEN DATEPART(second,MAX([EndTime])) + DATEPART(MICROSECOND,MAX([EndTime])) > 0 THEN 1 ELSE 0 END
		FROM @DetailLog_temp AS A
		GROUP BY [RoundID]

		UPDATE @RoundList
		SET [RoundID] = SUBSTRING([GameData],9,CHARINDEX(';',[GameData]) - 9)

		INSERT INTO [PerGameLog].[PerLog].[DetailLog]([LogID],[GameID],[ServerID],[UserID],[CurrentAmount],[UpdateAmount]
		,[GameTime],[days],[TradeID],[BetAmount],[BetCount],[FlowAmount],[WinLostAmount])
		SELECT A.[LogID],@GameID,@ServerID,B.[UserID],0,B.[Amount]
		,A.[GameTime],A.[DAYS],@JobID,0,0,0,0
		FROM @RoundList AS A JOIN @DetailLog_temp AS B ON A.[RoundID] = B.[RoundID]

		--更新排程紀錄
		UPDATE [LogDB].[ThirdParty].[TransformJobRecord]
		SET [Status] = 1, [UpdateTime] = GETDATE()
		WHERE [ID] = @JobID

	END

END