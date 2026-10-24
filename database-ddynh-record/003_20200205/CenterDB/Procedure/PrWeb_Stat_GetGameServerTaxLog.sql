USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Stat_GetGameServerTaxLog')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Stat_GetGameServerTaxLog] AS BEGIN RETURN END'
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
--	2018/03/19	Jason	調整寫法改用變數接參數
--	2019/03/27	Jason	新增PlatformID AreaID 對應 寫到新的[Stat].[StatisticsMoneySourceLog_New]
--	2020/03/04	Louis	#106增加用戶/系統有效投注、返還金額、輸贏流水統計
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Stat_GetGameServerTaxLog]
	@intAdminID		int,
	@intPlatformID	INT=NULL,
	@intAreaID		INT=NULL,
	@intGameID		INT=NULL,			--游戏ID	
	@intServerID	INT=NULL,			--服务器ID
	@dtBeginTime	DATETIME=NULL,		--开始时间范围
	@dtEndTime		DATETIME=NULL		--结束时间范围
AS
BEGIN	
	SET NOCOUNT ON

	--平台篩選
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	INSERT INTO @Temp_PlatformID Select PlatformID From CenterDB.Area.PlatformAdminUser where AdminID=@intAdminID

	DECLARE @GameID		INT = @intGameID
	DECLARE @ServerID	INT = @intServerID
	DECLARE @BeginTime	DATETIME = ISNULL(@dtBeginTime,'1900-01-01 00:00:00.000')
	DECLARE @EndTime	DATETIME = ISNULL(@dtEndTime,'2100-01-01 00:00:00.000')

	SELECT G.[GameName]
	,S.[ServerName]
	,CONVERT(DATE,A.StatTime,120) StatTime
	,SUM(A.[UserAmount]) AS Amount
	,SUM(A.[SystemAmount]) as RobotAmount
	,SUM(A.[SystemTaxAmount]) as RobotTaxAmount
	,SUM(A.[UserTaxAmount]) AS TaxAmount
	,SUM(A.[UserFlowAmount]) AS FlowAmount
	,SUM(A.[UserPayAmount]) AS PayAmount
	,SUM(A.[UserBetAmount]) AS BetAmount
	,SUM(A.[SystemPayAmount]) AS RobotPayAmount
	,SUM(A.[SystemBetAmount]) AS RobotBetAmount
	FROM [Stat].[GameAmountLog] AS A WITH (NOLOCK)
	JOIN [ServerInfo].GameList AS G WITH (NOLOCK) ON A.[GameID] = G.[GameID]
	JOIN ServerInfo.GameServerList AS S WITH (NOLOCK) ON A.[ServerID] = S.[ServerID]
	WHERE  (@GameID IS NULL OR G.[GameID] = @GameID)
	AND (@ServerID IS NULL OR S.[ServerID] = @ServerID)
	AND (@BeginTime IS NULL OR A.[StatTime] >= @BeginTime)
	AND (@EndTime IS NULL OR A.[StatTime] <= @EndTime)
	AND (@intPlatformID is null or A.[PlatformID] = @intPlatformID)
	AND (@intAreaID is null or A.[AreaID] = @intAreaID)
	AND A.[PlatformID] in (SELECT [PlatformID] FROM @Temp_PlatformID)
	GROUP BY CONVERT(DATE,A.StatTime,120),G.[GameID],G.[GameName],S.[ServerName]
	ORDER BY CONVERT(DATE,A.StatTime,120) DESC
	--END
	--------------------------------------------------------------------------------------------------------------------

END	