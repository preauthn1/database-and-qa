
-- =============================================
-- Author:		Mars
-- Create date: 2019/11/04
-- Description:	PerGameDetailLog統計資訊(小時)
--	2019/11/27	Mars		[bug]修正日報統計update時不會更新BetAmount,BetCount,FlowAmount,WinLostAmount
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_Stat_PerGameDetailLogStatistics]
(
	@dtStatTime	DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @LogStartTime		INT,
			@LogEndTime			INT,
			@LogMonthStartTime	DATETIME,
			@LogMonthEndTime	DATETIME
		
	SET @dtStatTime		= ISNULL(@dtStatTime, getdate())
	SET @LogStartTime	= DATEDIFF(MINUTE, 0, DATEADD(HOUR, -1, @dtStatTime))
	SET @LogEndTime		= DATEDIFF(MINUTE, 0, @dtStatTime)	

	/*  刪除現有紀錄  */
	----------------------------------------------------------------------------------------------------------------------------------------
	--DELETE FROM [Stat].[StatisticsPerGameDetailLog_Hour] WHERE @LogStartTime = [StatTime]
	----------------------------------------------------------------------------------------------------------------------------------------

	/*  統計暫存  */
	----------------------------------------------------------------------------------------------------------------------------------------
	--日報表統計
	SELECT	*
	INTO #Temp_SDD
	FROM (
			SELECT D.GameID, D.UserID, U.GradeID, @dtStatTime as GameTime, D.BetAmount, D.BetCount, D.FlowAmount, D.WinLostAmount, P.PlatformID, A.AreaID
			FROM (
				SELECT 
					  [GameID]
					  ,[UserID]
					  ,SUM([UpdateAmount]) as [WinLostAmount]
					  ,SUM([BetAmount]) as [BetAmount]
					  ,SUM([BetCount]) as [BetCount]
					  ,SUM([FlowAmount]) as [FlowAmount]
				FROM [PerGameLog].[PerLog].[DetailLog]
				WHERE Days BETWEEN @LogStartTime AND @LogEndTime
				GROUP BY UserID, GameID
			) AS D
			JOIN CenterDB.ServerInfo.GameList AS G ON G.GameID = D.GameID
			JOIN CenterDB.Users.UserInfo AS U ON U.UserID = D.UserID
			JOIN CenterDB.Area.Area AS A ON A.AreaID = U.AreaID
			JOIN CenterDB.Area.Platform AS P ON P.PlatformID = A.PlatformID
	) AS T
	----------------------------------------------------------------------------------------------------------------------------------------

	/*  寫入統計資料表  */
	----------------------------------------------------------------------------------------------------------------------------------------
	--日報表
	MERGE [Stat].[StatisticsPerGameDetailLog_Hour] AS S
	USING 
		(
			SELECT [GameID], [UserID], [GradeID], [GameTime], [BetAmount], [BetCount], [FlowAmount], [WinLostAmount], [PlatformID], [AreaID] 
			FROM #Temp_SDD
		) AS T ON (S.[GameTime] = T.[GameTime] AND S.[UserID] = T.[UserID] AND S.[PlatformID] = T.[PlatformID] AND S.[AreaID] = T.[AreaID] AND S.[GameID] = T.[GameID])
	WHEN MATCHED THEN
		UPDATE SET S.[BetAmount] = T.[BetAmount],
					S.[BetCount] = T.[BetCount],
					S.[FlowAmount] = T.[FlowAmount],
					S.[WinLostAmount] = T.[WinLostAmount]
	WHEN NOT MATCHED THEN
		INSERT
			(
				[GameID], [UserID], [GradeID], [GameTime], [BetAmount], [BetCount], [FlowAmount], [WinLostAmount], [PlatformID], [AreaID] 
			)
		VALUES
			(
				[GameID], 
				[UserID], 
				[GradeID], 
				[GameTime], 
				ISNULL([BetAmount], 0),
				ISNULL([BetCount], 0),
				ISNULL([FlowAmount], 0),
				ISNULL([WinLostAmount], 0),
				[PlatformID],
				[AreaID]
			);
	----------------------------------------------------------------------------------------------------------------------------------------

	DROP TABLE #Temp_SDD

	RETURN 1
END