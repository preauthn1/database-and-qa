USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_StatGameAmountLog')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_StatGameAmountLog] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Jason
-- Create date: 2018/05/24
-- Description:	遊戲稅收紀錄
-- 2020/03/04	Louis	增加用戶/系統有效投注、返還金額、輸贏流水統計
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_StatGameAmountLog]
(
	@dtStatTime DATETIME = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON

	SET	@dtStatTime = ISNULL(@dtStatTime,GETDATE())

	DECLARE @LogStartTime	DATETIME
	DECLARE @LogEndTime		DATETIME

	DECLARE @Temp_GameUserAmountLog TABLE ([StatTime] DATETIME,[PlatformID] INT,[AreaID] INT,[GameID] INT,[UserID] INT,[TotalAmount] BIGINT,[TotalTaxAmount] BIGINT)
	DECLARE @Temp_GameUserAmount	TABLE ([StatTime] DATETIME,[PlatformID] INT,[AreaID] INT,[GameID] INT,[UserAmount] BIGINT,[SystemAmount] BIGINT,[UserTaxAmount] BIGINT,[SystemTaxAmount] BIGINT)

	IF (DATEPART(HOUR,@dtStatTime) = 0) AND (DATEPART(MINUTE,@dtStatTime) < 10)
	BEGIN
		SET @LogStartTime		= DATEADD(DAY,-1,DATEDIFF(DAY,0,@dtStatTime))
		SET @LogEndTime			= DATEADD(DAY,0,DATEDIFF(DAY,0,@dtStatTime))
	END
	ELSE
	BEGIN
		SET @LogStartTime		= DATEADD(DAY,0,DATEDIFF(DAY,0,@dtStatTime))
		SET @LogEndTime			= DATEADD(DAY,1,DATEDIFF(DAY,0,@dtStatTime))
	END

	/*  更新統計數據  */
	------------------------------------------------------------------------------------------------------
	MERGE [Stat].[GameAmountLog] AS A
	USING 
	(
		SELECT	A.[StatTime],A.[PlatformID],A.[AreaID],A.[GameID],A.[ServerID],
		SUM(CASE WHEN B.[UserType] <> 2 THEN ISNULL(A.[TotalAmount],0) ELSE 0 END) AS [UserAmount],
		SUM(CASE WHEN B.[UserType] = 2  THEN ISNULL(A.[TotalAmount],0) ELSE 0 END) AS [SystemAmount],
		SUM(CASE WHEN B.[UserType] <> 2 THEN ISNULL(A.[TotalTaxAmount],0) ELSE 0 END) AS [UserTaxAmount],
		SUM(CASE WHEN B.[UserType] = 2  THEN ISNULL(A.[TotalTaxAmount],0) ELSE 0 END) AS [SystemTaxAmount],
		SUM(CASE WHEN B.[UserType] <> 2 THEN ISNULL(A.[FlowAmount],0) ELSE 0 END) AS [UserFlowAmount],
		SUM(CASE WHEN B.[UserType] = 2  THEN ISNULL(A.[FlowAmount],0) ELSE 0 END) AS [SystemFlowAmount],
		SUM(CASE WHEN B.[UserType] <> 2 THEN ISNULL(A.[BetAmount],0) ELSE 0 END) AS [UserBetAmount],
		SUM(CASE WHEN B.[UserType] = 2  THEN ISNULL(A.[BetAmount],0) ELSE 0 END) AS [SystemBetAmount],
		SUM(CASE WHEN B.[UserType] <> 2 THEN ISNULL(A.[PayAmount],0) ELSE 0 END) AS [UserPayAmount],
		SUM(CASE WHEN B.[UserType] = 2  THEN ISNULL(A.[PayAmount],0) ELSE 0 END) AS [SystemPayAmount]
		FROM [LogDB].[Stat].[StatisticsGameUserAmount] AS A WITH (NOLOCK)
		INNER JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.UserID = B.UserID
		WHERE [StatTime] >= @LogStartTime AND [StatTime] < @LogEndTime
		GROUP BY A.[StatTime],A.[PlatformID],A.[AreaID],A.[GameID],A.[ServerID]
	) AS B ON (A.[StatTime] = B.[StatTime] AND A.[PlatformID] = B.[PlatformID] AND A.[AreaID] = B.[AreaID] AND A.[GameID] = B.[GameID] AND A.[ServerID] = B.[ServerID])
	WHEN MATCHED THEN
		UPDATE SET	A.[UserAmount] = B.[UserAmount],
					A.[SystemAmount] = B.[SystemAmount],
					A.[UserTaxAmount] = B.[UserTaxAmount],
					A.[SystemTaxAmount] = B.[SystemTaxAmount],
					A.[UserFlowAmount] = B.[UserFlowAmount],
					A.[SystemFlowAmount] = B.[SystemFlowAmount],
					A.[UserBetAmount] = B.[UserBetAmount],
					A.[SystemBetAmount] = B.[SystemBetAmount],
					A.[UserPayAmount] = B.[UserPayAmount],
					A.[SystemPayAmount] = B.[SystemPayAmount]
	WHEN NOT MATCHED THEN
		INSERT ([StatTime],[PlatformID],[AreaID],[GameID],[ServerID],[UserAmount],[SystemAmount],[UserTaxAmount],[SystemTaxAmount]
		,[UserFlowAmount],[SystemFlowAmount],[UserBetAmount],[SystemBetAmount],[UserPayAmount],[SystemPayAmount])
		VALUES
		(B.[StatTime],B.[PlatformID],B.[AreaID],B.[GameID],B.[ServerID],B.[UserAmount],B.[SystemAmount],B.[UserTaxAmount],B.[SystemTaxAmount]
		,B.[UserFlowAmount],B.[SystemFlowAmount],B.[UserBetAmount],B.[SystemBetAmount],B.[UserPayAmount],B.[SystemPayAmount]);
END