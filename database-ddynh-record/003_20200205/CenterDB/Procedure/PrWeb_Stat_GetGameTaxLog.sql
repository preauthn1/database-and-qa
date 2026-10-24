USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Stat_GetGameTaxLog')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Stat_GetGameTaxLog] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<统计游戏税收记录>
--	2018/03/19	Jason		調整語法WHERE判斷方式並新增變數接參數
--	2019/03/25	Jason		新增遊戲獎池
--	2019/03/27	Jason		新增PlatformID AreaID 對應 寫到新的[Stat].[StatisticsMoneySourceLog_New]
--	2020/03/04	Louis		#106增加用戶/系統有效投注、返還金額、輸贏流水統計
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Stat_GetGameTaxLog]
	@intAdminID		int,
	@intPlatformID	INT=NULL,
	@intAreaID		INT=NULL,
	@intGameID		INT=NULL,			--游戏ID
	@dtBeginTime	DATETIME=NULL,		--开始时间范围
	@dtEndTime		DATETIME=NULL		--结束时间范围
AS
BEGIN

	--平台篩選
	DECLARE @Temp_PlatformID TABLE ([PlatformID] INT)
	INSERT INTO @Temp_PlatformID([PlatformID]) 
	SELECT [PlatformID] 
	FROM [CenterDB].[Area].[PlatformAdminUser] WITH (NOLOCK)
	WHERE [AdminID] = @intAdminID

	DECLARE	@GameID		INT			= ISNULL(@intGameID,0)
	DECLARE @BeginTime	DATETIME	= ISNULL(@dtBeginTime,'1900-01-01 00:00:00.000')
	DECLARE @EndTime	DATETIME	= ISNULL(@dtEndTime,'2100-01-01 00:00:00.000')
	DECLARE @Temp_Table	TABLE ([GameID] INT,[LogDate] DATETIME,[Amount] BIGINT)

		--因獎池被個別遊戲獨立切開  以下自行新增
	/*  GameID=2 搶庄牛牛 預設一開始獎池50000 需先扣掉  */
	INSERT INTO @Temp_Table([GameID],[LogDate],[Amount])
	SELECT 2,[LogDate],-[Amount] AS [Amount]
	FROM [Stat].[QZNN_PoolAmountDaily] WITH (NOLOCK)


	SELECT G.GameID AS 'Game.Id'
	,G.GameName AS 'Game.GameName'
	,G.GameID AS GameID
	,CONVERT(DATE,A.StatTime,120) StatTime
	,SUM(A.[UserAmount]) AS Amount
	,SUM(A.[SystemAmount]) as RobotAmount
	,SUM(A.[SystemTaxAmount]) as RobotTaxAmount
	,SUM(A.[UserTaxAmount]) AS TaxAmount
	,ISNULL(H.Amount,0) AS PoolAmount
	,SUM(A.[UserFlowAmount]) AS FlowAmount
	,SUM(A.[UserPayAmount]) AS PayAmount
	,SUM(A.[UserBetAmount]) AS BetAmount
	,SUM(A.[SystemPayAmount]) AS RobotPayAmount
	,SUM(A.[SystemBetAmount]) AS RobotBetAmount
	FROM [Stat].[GameAmountLog] AS A WITH (NOLOCK)
	JOIN [ServerInfo].GameList AS G WITH (NOLOCK) ON A.[GameID] = G.[GameID]
	LEFT JOIN @Temp_Table AS H ON G.[GameID] = H.[GameID] AND A.[StatTime] = H.[LogDate]
	WHERE (@GameID = 0 OR G.GameID=@GameID)
	AND A.StatTime >= @BeginTime
	AND A.StatTime <= @EndTime
	AND (@intPlatformID is null or A.PlatformID = @intPlatformID)
	AND (@intAreaID is null or A.AreaID = @intAreaID)
	AND A.PlatformID in (select platformid from @Temp_PlatformID)
	GROUP BY CONVERT(DATE,A.StatTime,120),G.GameID,G.GameName,ISNULL(H.Amount,0)
	ORDER BY CONVERT(DATE,A.StatTime,120) DESC

END
