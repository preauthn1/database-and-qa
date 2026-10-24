USE [LogDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_Stat_GameUserAmountLog')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_Stat_GameUserAmountLog] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jason
-- Create date: 2018/05/24
-- Description:	統計遊戲用戶稅收
-- 2020/03/04	Louis	增加FlowAmount、BetAmount、PayAmount
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_Stat_GameUserAmountLog]
(
	@dtStatTime DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @dtStatTime = ISNULL(@dtStatTime,GETDATE())

	DECLARE @LogStartTime			DATETIME
	DECLARE @LogEndTime				DATETIME

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

	MERGE [Stat].[StatisticsGameUserAmount] AS A
	USING 
	(
		SELECT	[StatTime] = @LogStartTime,
				[PlatformID],
				[AreaID],
				[GameID],
				[ServerID],
				[UserID],
				SUM([Amount])		AS [TotalAmount],
				SUM([TaxAmount])	AS [TotalTaxAmount],
				SUM([FlowAmount])	AS [FlowAmount],
				SUM([BetAmount])	AS [BetAmount],
				SUM([PayAmount])	AS [PayAmount]
		FROM [Game].[GameLog] WITH (NOLOCK)
		WHERE [LogoutTime] >= @LogStartTime AND [LogoutTime] <= @LogEndTime
		GROUP BY [PlatformID],[AreaID],[GameID],[ServerID],[UserID]
	) AS B ON 
	(
		A.[StatTime] = B.[StatTime] 
		AND A.[PlatformID] = B.[PlatformID] 
		AND A.[AreaID] = B.[AreaID] 
		AND A.[GameID] = B.[GameID]
		AND A.[ServerID] = B.[ServerID]
		AND A.[UserID] = B.[UserID]
	)
	WHEN MATCHED THEN
		UPDATE SET	A.[TotalAmount]		= ISNULL(B.[TotalAmount],0),
					A.[TotalTaxAmount]	= ISNULL(B.[TotalTaxAmount],0),
					A.[FlowAmount]		= ISNULL(B.[FlowAmount],0),
					A.[BetAmount]		= ISNULL(B.[BetAmount],0),
					A.[PayAmount]		= ISNULL(B.[PayAmount],0)
	WHEN NOT MATCHED THEN
		INSERT
			([StatTime],[PlatformID],[AreaID],[GameID],[ServerID],[UserID],[TotalAmount],[TotalTaxAmount]
			,[FlowAmount],[BetAmount],[PayAmount])
		VALUES
			(B.[StatTime],B.[PlatformID],B.[AreaID],B.[GameID],B.[ServerID],B.[UserID],ISNULL(B.[TotalAmount],0),ISNULL(B.[TotalTaxAmount],0)
			,ISNULL(B.[FlowAmount],0),ISNULL(B.[BetAmount],0),ISNULL(B.[PayAmount],0));

	RETURN
END