USE [LogDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_Transform_APLFish')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_Transform_APLFish] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Louis
-- Create date: 2020/04/27
-- Description:	APL Fish資料轉換 APLFishBetRecord -> GameLog, PerGameLog, DetailLog
-- 2020/04/29	Louis	修正初始化@StartTime取值方式
-- 2020/05/04	Louis	因應API回補資料時會更新UpdateTime，轉資料改採用CreateTime
-- 2020/05/04	Louis	使用TransformIDRecord來排除已經處理過的紀錄
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_Transform_APLFish]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @GameMerchantCode NVARCHAR(20) = 'APLFish'
	DECLARE @GameID INT = 9051
	DECLARE @ServerID INT = (SELECT TOP 1 [ServerID] FROM [CenterDB].[ServerInfo].[GameServerList] WITH(NOLOCK) WHERE [GameID] = @GameID)
	DECLARE @TableName NVARCHAR(50) = 'GameLog'
	DECLARE @JobID INT = NULL
	DECLARE @StartTime DATETIME = NULL
	DECLARE @EndTime DATETIME = NULL

	DECLARE @List TABLE([ID] BIGINT)

	SET @ServerID = ISNULL(@ServerID,@GameID)
	/*-----處理[LogDB].[Game].[GameLog]-----*/
	--取得上次最後處理的紀錄編號(有成功的排程)
	SELECT TOP 1 @StartTime = [EndTime] FROM [LogDB].[ThirdParty].[TransformJobRecord] WITH(NOLOCK)
	WHERE [GameMerchantCode] = @GameMerchantCode AND [GameID] = @GameID AND [ServerID] = @ServerID 
	AND [Status] = 1 AND [TableName] = @TableName
	ORDER BY ID DESC 
	--SET @StartTime = ISNULL(@StartTime,CONVERT(DATE,GETDATE()))
	--取得本次排程要處理的起訖紀錄編號
	SELECT @EndTime = MAX([CreateTime]),@StartTime = ISNULL(@StartTime,CONVERT(DATE,MIN([CreateTime])))
	FROM [LogDB].[ThirdParty].[APLFishBetRecord] WITH(NOLOCK) WHERE (@StartTime IS NULL OR [CreateTime] >= @StartTime)

	--確認本次是否有需要處理的資料
	IF @StartTime is not null AND @EndTime is not null
	BEGIN
		--先記錄一筆排程紀錄，取得流水編號
		INSERT INTO [LogDB].[ThirdParty].[TransformJobRecord]([GameMerchantCode],[GameID],[ServerID],[TableName],[Status],[StartTime],[EndTime],[CreateTime],[UpdateTime])
		VALUES(@GameMerchantCode,@GameID,ISNULL(@ServerID,0),@TableName,0,@StartTime,@EndTime,GETDATE(),GETDATE())

		SET @JobID = @@IDENTITY
		--先將資料存放到暫存表中
		DECLARE @GameLog_temp TABLE
		(
			[PlatformID] INT,[UserID] INT,[AreaID] INT,[Amount] BIGINT,[FlowAmount] BIGINT,[WinCount] INT,[LoseCount] INT,[DrawCount] INT
			,[UserIPAddress] VARCHAR(15),[LoginTime] DATETIME,[LogoutTime] DATETIME,[BetAmount] BIGINT,[PayAmount] BIGINT
		)
		--先抓出要進行轉換的紀錄ID
		INSERT INTO @List([ID])
		SELECT DISTINCT E.[ID]
		FROM [LogDB].[ThirdParty].[APLFishBetRecord] AS E WITH(NOLOCK)
		LEFT JOIN [LogDB].[ThirdParty].[TransformIDRecord] AS R WITH(NOLOCK) ON R.[RecordID] = E.[ID]
		AND R.[GameMerchantCode] = @GameMerchantCode AND R.TableName = @TableName
		WHERE E.[CreateTime] > @StartTime AND E.[CreateTime] <= @EndTime
		AND R.[ID] IS NULL

		INSERT INTO @GameLog_temp([PlatformID],[UserID],[AreaID],[Amount],[FlowAmount],[WinCount],[LoseCount],[DrawCount]
		,[UserIPAddress],[LoginTime],[LogoutTime],[BetAmount],[PayAmount])
		SELECT [PlatformID] AS [PlatformID]
		,E.[UserID] AS [UserID]
		,U.[AreaID] AS [AreaID]
		,SUM(E.[WinLossAmount]) AS [Amount]
		,SUM(E.[BetAmount]) AS [FlowAmount]
		,SUM(CASE WHEN E.[WinLossAmount] > 0 THEN 1 ELSE 0 END) AS [WinCount]
		,SUM(CASE WHEN E.[WinLossAmount] < 0 THEN 1 ELSE 0 END) AS [LoseCount]
		,SUM(CASE WHEN E.[WinLossAmount] = 0 THEN 1 ELSE 0 END) AS [DrawCount]
		,E.[UserIPAddress] AS [IPAddress]
		,DATEADD(HH,8,MIN(E.[StartTimeUTC])) AS [LoginTime]
		,DATEADD(HH,8,MAX(E.[EndTimeUTC])) AS [LogoutTime]
		,SUM(E.[BetAmount]) AS [BetAmount]
		,SUM(E.[WinLossAmount] + E.[BetAmount]) AS [PayAmount]
		FROM [LogDB].[ThirdParty].[APLFishBetRecord] AS E WITH(NOLOCK)
		JOIN [CenterDB].[Users].[UserInfo] AS U WITH(NOLOCK) ON U.[UserID] = E.[UserID] AND U.[UserType] != 2
		JOIN @List AS R ON R.[ID] = E.[ID]
		GROUP BY E.[PlatformID],E.[UserID],E.[UserIPAddress],U.[AreaID] 

		--新增[LogDB].[Game].[GameLog]
		INSERT INTO [LogDB].[Game].[GameLog]([PlatformID],[AreaID],[GameID],[ServerID],[UserID],[TradeID]
		,[LoginMoney],[Amount],[TaxAmount],[FlowAmount],[WinCount],[LoseCount],[DrawCount],[GameTime]
		,[IPAddress],[HDCode],[HDType],[LoginTime],[LogoutTime],[BetAmount],[PayAmount])
		SELECT [PlatformID],[AreaID],@GameID AS [GameID],@ServerID AS [ServerID],[UserID],ISNULL(@JobID,0) AS [TradeID]
		,0 AS [LoginMoney],[Amount],0 AS [TaxAmount],[FlowAmount],[WinCount],[LoseCount],[DrawCount],0 AS [GameTime]
		,[UserIPAddress],'000000' AS [HDCode],1 AS [HDType],[LoginTime],[LogoutTime],[BetAmount],[PayAmount]
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

		--紀錄處理過的ID
		INSERT INTO [LogDB].[ThirdParty].[TransformIDRecord]([GameMerchantCode],[TableName],[RecordID],[CreateTime])
		SELECT @GameMerchantCode,@TableName,[ID],GETDATE()
		FROM @List

	END

	/*-----處理[PerGameLog].[PerLog].[PerGameLog]-----*/
	SET @TableName = 'PerGameLog'
	SET @StartTime = null
	SET @EndTime = null
	--取得上次最後處理的紀錄編號(有成功的排程)
	SELECT TOP 1 @StartTime = [EndTime] FROM [LogDB].[ThirdParty].[TransformJobRecord]
	WHERE [GameMerchantCode] = @GameMerchantCode AND [GameID] = @GameID AND [ServerID] = @ServerID 
	AND [Status] = 1 AND [TableName] = @TableName
	ORDER BY ID DESC 
	--SET @StartTime = ISNULL(@StartTime,CONVERT(DATE,GETDATE()))
	--取得本次排程要處理的起訖紀錄編號
	SELECT @EndTime = MAX([CreateTime]),@StartTime = ISNULL(@StartTime,CONVERT(DATE,MIN([CreateTime])))
	FROM [LogDB].[ThirdParty].[APLFishBetRecord] WITH(NOLOCK) WHERE (@StartTime IS NULL OR [CreateTime] >= @StartTime)

	DELETE @List
	--確認本次是否有需要處理的資料
	IF @StartTime is not null AND @EndTime is not null
	BEGIN
		--先記錄一筆排程紀錄，取得流水編號
		INSERT INTO [LogDB].[ThirdParty].[TransformJobRecord]([GameMerchantCode],[GameID],[ServerID],[TableName],[Status],[StartTime],[EndTime],[CreateTime],[UpdateTime])
		VALUES(@GameMerchantCode,@GameID,ISNULL(@ServerID,0),@TableName,0,@StartTime,@EndTime,GETDATE(),GETDATE())

		SET @JobID = @@IDENTITY

		DELETE @List

		INSERT INTO @List([ID])
		SELECT DISTINCT E.[ID]
		FROM [LogDB].[ThirdParty].[APLFishBetRecord] AS E WITH(NOLOCK)
		LEFT JOIN [LogDB].[ThirdParty].[TransformIDRecord] AS R WITH(NOLOCK) ON R.[RecordID] = E.[ID]
		AND R.[GameMerchantCode] = @GameMerchantCode AND R.TableName = @TableName
		WHERE E.[CreateTime] > @StartTime AND E.[CreateTime] <= @EndTime
		AND R.[ID] IS NULL

		DECLARE @RoundList TABLE([LogID] BIGINT,[GameData] NVARCHAR(MAX),[GameTime] DATETIME,[DAYS] INT,[BetRecordNo] NVARCHAR(50))
		DECLARE @DetailLog_temp TABLE(UserID BIGINT, BetRecordNo NVARCHAR(50),Amount BIGINT,StartTime DATETIME,EndTime DATETIME,GameType NVARCHAR(20))

		INSERT INTO @DetailLog_temp([UserID],[BetRecordNo],[Amount],[StartTime],[EndTime],[GameType])
		SELECT E.[UserID],E.[BetRecordNo]
		,SUM([WinLossAmount]) AS [Amount]
		,DATEADD(HH,8,CONVERT(DATETIME,CONVERT(VARCHAR,MIN([StartTimeUTC]),120))) AS [StartTime]
		,DATEADD(HH,8,CONVERT(DATETIME,CONVERT(VARCHAR,MAX([EndTimeUTC]),120))) AS [EndTime]
		,[GameType] AS [GameType]
		FROM [LogDB].[ThirdParty].[APLFishBetRecord] AS E WITH(NOLOCK)
		JOIN [CenterDB].[Users].[UserInfo] AS U WITH(NOLOCK) ON U.[UserID] = E.[UserID]
		AND U.[UserType] != 2
		JOIN @List AS R ON R.[ID] = E.[ID]
		GROUP BY E.[UserID],E.[BetRecordNo],E.[GameType]

		INSERT INTO [PerGameLog].[PerLog].[PerGameLog]([GameID],[ServerID],[GameData],[TaxAmount],[BeginTime],[EndTime],[days])
		OUTPUT inserted.[Id],inserted.[GameData],inserted.[EndTime],inserted.[days]
		INTO @RoundList([LogID],[GameData],[GameTime],[DAYS])
		SELECT @GameID,@ServerID
		,[GameType] + '-' + [BetRecordNo] as [GameData]
		,0,[StartTime],[EndTime]
		,DATEDIFF(MINUTE,0,[EndTime]) + CASE WHEN DATEPART(second,[EndTime]) + DATEPART(MICROSECOND,[EndTime]) > 0 THEN 1 ELSE 0 END
		FROM @DetailLog_temp AS A

		UPDATE @RoundList
		SET [BetRecordNo] = SUBSTRING([GameData],CHARINDEX('-',[GameData]) + 1,LEN([GameData]) - CHARINDEX('-',[GameData]))

		INSERT INTO [PerGameLog].[PerLog].[DetailLog]([LogID],[GameID],[ServerID],[UserID],[CurrentAmount],[UpdateAmount]
		,[GameTime],[days],[TradeID],[BetAmount],[BetCount],[FlowAmount],[WinLostAmount])
		SELECT A.[LogID],@GameID,@ServerID,B.[UserID],0,B.[Amount]
		,A.[GameTime],A.[DAYS],@JobID,0,0,0,0
		FROM @RoundList AS A JOIN @DetailLog_temp AS B ON A.[BetRecordNo] = B.[BetRecordNo]

		--更新排程紀錄
		UPDATE [LogDB].[ThirdParty].[TransformJobRecord]
		SET [Status] = 1, [UpdateTime] = GETDATE()
		WHERE [ID] = @JobID

		--紀錄處理過的ID
		INSERT INTO [LogDB].[ThirdParty].[TransformIDRecord]([GameMerchantCode],[TableName],[RecordID],[CreateTime])
		SELECT @GameMerchantCode,@TableName,[ID],GETDATE()
		FROM @List
	END

END
GO