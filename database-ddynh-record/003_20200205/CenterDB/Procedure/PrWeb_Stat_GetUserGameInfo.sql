USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Stat_GetUserGameInfo')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Stat_GetUserGameInfo] AS BEGIN RETURN END'
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
-- Description:	<统计用户查询时间范围的游戏统计信息>
--	2018/03/21	Jason		調整查詢語法改為LINKSERVER
-- 	2020/03/24 	Mars 		#106 RTP 增加回傳BetAmount/PayAmount
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Stat_GetUserGameInfo]
	@intUserID		INT,				--用户ID
	@dtBeginTime	DATETIME = NULL,	--开始时间范围
	@dtEndTime		DATETIME = NULL		--结束时间范围
AS
BEGIN
	
	SET NOCOUNT ON

	/*  取資料及回傳  */
	-------------------------------------------------------------------------------------------------
	CREATE TABLE #Temp_UserGameLog (ServerID INT,WinCount INT,LoseCount INT,DrawCount INT,Score BIGINT,GameTime INT,BetAmount BIGINT,PayAmount BIGINT)

	INSERT INTO #Temp_UserGameLog
	EXEC [LOGDBLINKEDSERVER].[LogDB].[dbo].[PrPs_GetUserGameLog]
		@intUserID = @intUserID,
		@dtStatTime  = @dtBeginTime,
		@dtEndTime	= @dtEndTime

	SELECT	G.GameID,
			G.GameName AS 'Game.GameName',
			ISNULL(SUM(L.WinCount),0) AS WinCount,
			ISNULL(SUM(L.LoseCount),0) AS LoseCount,
			ISNULL(SUM(L.DrawCount),0) AS DrawCount,
			ISNULL(SUM(L.Score),0) AS Score,
			ISNULL(SUM(L.GameTime),0) AS GameTime,
			ISNULL(SUM(L.BetAmount),0) AS BetAmount,
			ISNULL(SUM(L.PayAmount),0) AS PayAmount
	FROM #Temp_UserGameLog AS L
		INNER JOIN ServerInfo.GameServerList AS GL WITH (NOLOCK) ON L.ServerID = GL.ServerID
		INNER JOIN ServerInfo.GameList AS G WITH (NOLOCK) ON G.GameID = GL.GameID
	GROUP BY G.GameID,G.GameName
	-------------------------------------------------------------------------------------------------
	
	DROP TABLE #Temp_UserGameLog

END
