
-- =============================================
-- Author:		Mars
-- Create date: 2019/11/01
-- Description:	流水報表
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Stat_GetPerGameDetailLog]
(
	@intAdminID		INT,
	@intUserID		INT = NULL,		--用户ID
	@intGameID		INT = NULL,		--遊戲ID
	@intPlatformID	INT = NULL,		--平台ID
	@intAreaID		INT = NULL,		--渠道ID
	@dtStatTime		DATETIME = NULL,
	@dtEndTime		DATETIME = NULL,
	@intPageIndex	INT = 1,
	@intPageSize	INT = 20,
	@intPageCount	INT = 0 OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @SumBetAmount BIGINT = 0,
			@SumBetCount BIGINT = 0,
			@SumFlowAmount BIGINT = 0,
			@SumWinLostAmount BIGINT = 0
			
	

	SELECT @intPageCount = COUNT(1),
			@SumBetAmount = ISNULL(SUM(BetAmount), 0),
			@SumBetCount = ISNULL(SUM(BetCount), 0),
			@SumFlowAmount = ISNULL(SUM(FlowAmount), 0),
			@SumWinLostAmount = ISNULL(SUM(WinLostAmount), 0)
	FROM LogDB.Stat.StatisticsPerGameDetailLog_Hour AS D WITH (NOLOCK)
	INNER JOIN CenterDB.Area.Platform as P WITH (NOLOCK) ON P.PlatformID = D.PlatformID
	INNER JOIN CenterDB.Area.Area as A WITH (NOLOCK) ON A.AreaID = D.AreaID
	INNER JOIN CenterDB.ServerInfo.GameList as G WITH (NOLOCK)  ON G.GameID = D.GameID
	--WHERE
	--	(@PlatformID IS NULL OR [PlatformID] = @PlatformID)
	--	AND (@AreaID IS NULL OR [AreaID] = @AreaID)
	--	AND (@intSourceID IS NULL OR [SourceID] = @intSourceID)
	--	AND (@LogStartTime IS NULL OR [CreateTime] >= @LogStartTime)
	--	AND (@LogEndTime IS NULL OR [CreateTime] < @LogEndTime)
	
	;WITH CTE AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY D.[GameTime] DESC) AS RowNum,
				D.[GameID],
				G.[GameName],
				D.[UserID],
				D.[GradeID],
				D.[GameTime] as [Date],
				D.[BetAmount],
				D.[BetCount],
				D.[FlowAmount],
				D.[WinLostAmount],
				D.[PlatformID],
				P.Name as [PlatformName],
				D.[AreaID],
				A.AreaName as [AreaName]
		FROM LogDB.Stat.StatisticsPerGameDetailLog_Hour AS D WITH (NOLOCK)
		INNER JOIN CenterDB.Area.Platform as P WITH (NOLOCK) ON P.PlatformID = D.PlatformID
		INNER JOIN CenterDB.Area.Area as A WITH (NOLOCK) ON A.AreaID = D.AreaID
		INNER JOIN CenterDB.ServerInfo.GameList as G WITH (NOLOCK)  ON G.GameID = D.GameID
		--WHERE
		--	(@PlatformID IS NULL OR [PlatformID] = @PlatformID)
		--	AND (@AreaID IS NULL OR [AreaID] = @AreaID)
		--	AND (@intSourceID IS NULL OR [SourceID] = @intSourceID)
		--	AND (@LogStartTime IS NULL OR [CreateTime] >= @LogStartTime)
		--	AND (@LogEndTime IS NULL OR [CreateTime] < @LogEndTime)
	)

	SELECT * FROM CTE WHERE RowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex

	SELECT @SumBetAmount as SumBetAmount, @SumBetCount as umBetCount, @SumFlowAmount as SumFlowAmount, @SumWinLostAmount as SumWinLostAmount

	RETURN 1
	
END