USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_GetOnlineSummary')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_GetOnlineSummary] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO

/****** Object:  StoredProcedure [dbo].[PrWeb_GetOnlineSummary]    Script Date: 2020/2/18 上午 11:20:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  alan
-- Create date: 20181219
-- Description:	在線玩家總匯

--	2019/06/17		Jason			新增多福多財 @TotalOnlineGame25
--	2020/02/18		Marshall		@TotalOnlineGame1 ~ @TotalOnlineGame9999 不再使用這些欄位(改在SP PrWeb_GetOnlineSummary_EachGame 處理)
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_GetOnlineSummary]
(
	@intAdminID					INT,
	@intGameID					INT = NULL,
    @intServerID				INT = NULL,	
	@intPageIndex				INT = 1,
	@intPageSize				INT = 20,
	@tnyColumns					TINYINT = 0,		--0:總充值 1:總兌換 2:金幣 3:銀行 4:累計輸贏 5:ServerName
	@tnySort					TINYINT = 1,		--0:升序 1:降序
	@intPageCount				INT = 0	OUTPUT,	--记录总数	
	@TotalOnlineCount			INT = 0	OUTPUT,	--總在线
	@TotalOnlineiOSCount		INT = 0	OUTPUT,	--IOS在线
	@TotalOnlineAndroidCount	INT = 0	OUTPUT,	--AndRoid在线
	@TotalOnlineHallCount		INT = 0	OUTPUT,	--大廳在线
	@TotalOnlineGameRoomCount	INT = 0	OUTPUT,	--正在遊戲房間
	@TotalOnlineRegCount		INT = 0	OUTPUT,	--當天注冊在线
	@TotalOnlineRegWeeklyCount	INT = 0	OUTPUT,	--1-7天注冊在线
	@TotalOnlineAvgCount		INT = 0	OUTPUT,	--當天平均在线
	@TotalOnlineAvgAndRoidCount	INT = 0	OUTPUT,	--當天AndRoid平均在线
	@TotalOnlineAvgiOSCount		INT = 0	OUTPUT,	--當天iOS平均在线
	@TotalOnlineMaxCount		INT = 0	OUTPUT,	--當天最高在线
	@TotalOnlineMaxiOSCount		INT = 0	OUTPUT,	--當天IOS最高在线
	@TotalOnlineMaxAndRoidCount	INT = 0	OUTPUT,	--當天AndRoid最高在线
	@TotalOnlineGame1			INT = 0	OUTPUT, --鬥地主
	@TotalOnlineGame2			INT = 0	OUTPUT, --搶莊牛牛
	@TotalOnlineGame3			INT = 0	OUTPUT, --炸金花
	@TotalOnlineGame4			INT = 0	OUTPUT, --德州撲克
	@TotalOnlineGame5			INT = 0	OUTPUT, --梭哈
	@TotalOnlineGame6			INT = 0	OUTPUT, --抢庄21点
	@TotalOnlineGame7			INT = 0	OUTPUT, --經典牛牛
	@TotalOnlineGame8			INT = 0	OUTPUT, --三公
	@TotalOnlineGame9			INT = 0	OUTPUT, --水果機
	@TotalOnlineGame10			INT = 0	OUTPUT, --十三水
	@TotalOnlineGame11			INT = 0	OUTPUT, --龍虎鬥
	@TotalOnlineGame12			INT = 0	OUTPUT, --推筒子
	@TotalOnlineGame13			INT = 0	OUTPUT, --百家樂
	@TotalOnlineGame14			INT = 0	OUTPUT, --捕魚
	@TotalOnlineGame15			INT = 0	OUTPUT, --四川麻將
	@TotalOnlineGame16			INT = 0	OUTPUT,	--2人牛牛
	@TotalOnlineGame17			INT = 0	OUTPUT,	--2人麻將
	@TotalOnlineGame18			INT = 0	OUTPUT, --疯狂二八
	@TotalOnlineGame19			INT = 0	OUTPUT,	--百人牛牛
	@TotalOnlineGame20			INT = 0	OUTPUT,	--紅黑大戰
	@TotalOnlineGame21			INT = 0	OUTPUT,	--紅黑牛牛
	@TotalOnlineGame22			INT = 0	OUTPUT,	--21点
	@TotalOnlineGame23			INT = 0	OUTPUT,	--老虎机
	@TotalOnlineGame24			INT = 0	OUTPUT,	--新捕魚
	@TotalOnlineGame25			INT = 0	OUTPUT	--多福多財
)
AS
BEGIN
	
	SET NOCOUNT ON

	DECLARE @GameID		INT = @intGameID
	DECLARE @StatTime	DATETIME = GETDATE()-1
	DECLARE @EndTime	DATETIME = GETDATE()
	DECLARE @WeekTime	DATETIME = GETDATE()-7


	--渠道篩選
	DECLARE @Temp_AreaID TABLE (AreaID	INT)
	INSERT INTO @Temp_AreaID Select AreaID From Area.AreaAdminUser where AdminID=@intAdminID


	
	--總在线
	--IOS在线
	--AndRoid在线
	SELECT	@TotalOnlineCount = COUNT(1),
			@TotalOnlineiOSCount = COUNT(CASE WHEN HDType = 3 THEN UserID ELSE NULL END),
			@TotalOnlineAndroidCount = COUNT(CASE WHEN HDType = 2 THEN UserID ELSE NULL END)
				
	FROM (

			SELECT DISTINCT A.UserID,A.HDType
			FROM [Game].[GameUserList] AS A WITH (NOLOCK)
				INNER JOIN [Users].[UserInfo] AS B ON A.UserID = B.UserID AND B.UserType <> 2
			WHERE B.AreaID in (select AreaID from @Temp_AreaID)
		) AS A
	

	--大廳在线
	SELECT	@TotalOnlineHallCount = COUNT(1)
	FROM [Game].[HallUserList] AS A WITH (NOLOCK)
		INNER JOIN [Users].[UserInfo] AS B ON A.UserID = B.UserID AND B.UserType <> 2
	WHERE B.AreaID in (select AreaID from @Temp_AreaID)

	--正在遊戲房間
	SELECT	@TotalOnlineGameRoomCount = COUNT(1)
	FROM [Game].[GameUserList] AS A WITH (NOLOCK)
		INNER JOIN [Users].[UserInfo] AS B ON A.UserID = B.UserID AND B.UserType <> 2
	WHERE B.AreaID in (select AreaID from @Temp_AreaID)

	--當天注冊在线
	--1-7天注冊在线
	SELECT	@TotalOnlineRegCount = COUNT(CASE WHEN CreateTime >= @StatTime AND CreateTime < @EndTime THEN A.UserID ELSE NULL END),
			@TotalOnlineRegWeeklyCount = COUNT(CASE WHEN CreateTime >= @WeekTime AND CreateTime < @EndTime THEN A.UserID ELSE NULL END)
	FROM [Users].[UserInfo] AS A WITH (NOLOCK)
		INNER JOIN (
						SELECT DISTINCT A.UserID
						FROM [Game].[GameUserList] AS A WITH (NOLOCK)
							INNER JOIN [Users].[UserInfo] AS B ON A.UserID = B.UserID AND B.UserType <> 2
					) AS B ON A.UserID = B.UserID
	WHERE A.AreaID in (select AreaID from @Temp_AreaID)



	--當天平均在线
	--當天iOS平均在线
	--當天AndRoid平均在线
	SELECT	@TotalOnlineAvgCount = SUM([TotalCount]),
			@TotalOnlineAvgiOSCount = SUM([IOSCount]),
			@TotalOnlineAvgAndRoidCount = SUM([AndroidCount])
	FROM (	
			SELECT	TotalCount = TotalCount / 24,
					IOSCount = IOSCount / 24,
					AndroidCount = AndroidCount / 24
			FROM Stat.DAULog WITH (NOLOCK)
			WHERE
				PlatformID = 0 AND AreaID = 0 AND GameID = 0
				AND [StatTime] >= @StatTime
				AND [StatTime] < DATEADD(DAY,0,DATEDIFF(DAY,0,@EndTime))
			UNION ALL
			SELECT	TotalCount = CASE WHEN DATEPART(HOUR,@EndTime) = 0 THEN TotalCount ELSE TotalCount / DATEPART(HOUR,@EndTime) END,
					IOSCount = CASE WHEN DATEPART(HOUR,@EndTime) = 0 THEN IOSCount ELSE IOSCount / DATEPART(HOUR,@EndTime) END,
					AndroidCount = CASE WHEN DATEPART(HOUR,@EndTime) = 0 THEN AndroidCount ELSE AndroidCount / DATEPART(HOUR,@EndTime) END
			FROM Stat.DAULog WITH (NOLOCK)
			WHERE
				PlatformID = 0 AND AreaID = 0 AND GameID = 0
				AND [StatTime] >= DATEADD(DAY,0,DATEDIFF(DAY,0,@EndTime))
				AND [StatTime] < @EndTime
	) AS A


	--當天最高在线
	--當天IOS最高在线
	--當天AndRoid最高在线
	SELECT	@TotalOnlineMaxCount = SUM(Total),
			@TotalOnlineMaxiOSCount = SUM(iOS),
			@TotalOnlineMaxAndRoidCount = SUM(AndRoid)
	FROM (
			--SELECT	Total = MAX([TotalCount]),
			--		iOS = MAX([IOSCount]),
			--		AndRoid = MAX([AndroidCount])
			--FROM [Stat].[HallOnLineUserLog] WITH (NOLOCK)
			--WHERE
			--	[StatTime] >= @StatTime AND [StatTime] < @EndTime
			--UNION ALL
			SELECT	Total = MAX([TotalCount]),
					iOS = MAX([IOSCount]),
					AndRoid = MAX([AndroidCount])
			FROM [Stat].[GameOnLineUserLog] WITH (NOLOCK)
			WHERE
				[StatTime] >= @StatTime AND [StatTime] < @EndTime
		) AS A



	--大重構～～～　@TotalOnlineGame1系列參數不再有意義
	--大重構～～～　@TotalOnlineGame1系列參數不再有意義
	--大重構～～～　@TotalOnlineGame1系列參數不再有意義
	--大重構～～～　@TotalOnlineGame1系列參數不再有意義
	--大重構～～～　@TotalOnlineGame1系列參數不再有意義



	SELECT	@intPageCount = COUNT(1)
	FROM [Game].[GameUserList] AS A WITH (NOLOCK)
		INNER JOIN [ServerInfo].[GameServerList] AS B ON A.ServerID = B.ServerID
		INNER JOIN [ServerInfo].[GameList] AS C WITH (NOLOCK) ON B.GameID = C.GameID
		INNER JOIN [Users].[UserInfo] AS F WITH (NOLOCK) ON A.UserID = F.UserID AND F.UserType <> 2
		INNER JOIN [Money].[Cash] AS G WITH (NOLOCK) ON F.UserID = G.UserID
		INNER JOIN [Money].[Bank] AS H WITH (NOLOCK) ON F.UserID = H.UserID
		LEFT JOIN [Game].[UserGameInfo] AS I WITH (NOLOCK) ON B.GameID = I.GameID AND F.UserID = I.UserID
		LEFT JOIN Area.Area as R WITH (NOLOCK) ON F.AreaID = R.AreaID
	WHERE
		ISNULL(@GameID,B.GameID) = B.GameID
		AND ISNULL(@intServerID,B.ServerID) = B.ServerID
		AND F.AreaID in (select AreaID from @Temp_AreaID)
			
	;WITH CTE AS
	(	SELECT	ROW_NUMBER() OVER (ORDER BY CASE	WHEN  @tnyColumns = 0 AND @tnySort = 1 THEN (F.SumCharge + F.SumAgentCharge)
													WHEN  @tnyColumns = 0 AND @tnySort = 0 THEN (0 - (F.SumCharge + F.SumAgentCharge))
													WHEN  @tnyColumns = 1 AND @tnySort = 1 THEN F.SumConvert
													WHEN  @tnyColumns = 1 AND @tnySort = 0 THEN (0 - F.SumConvert)
													WHEN  @tnyColumns = 2 AND  @tnySort = 1 THEN G.Amount
													WHEN  @tnyColumns = 2 AND  @tnySort = 0 THEN (0 - G.Amount)
													WHEN  @tnyColumns = 3 AND  @tnySort = 1 THEN H.Amount
													WHEN  @tnyColumns = 3 AND  @tnySort = 0 THEN (0 - H.Amount)
													WHEN  @tnyColumns = 4 AND  @tnySort = 1 THEN ((F.SumCharge+F.SumAgentCharge) - F.SumConvert - G.Amount - H.Amount)
													WHEN  @tnyColumns = 4 AND  @tnySort = 0 THEN (0 - ((F.SumCharge+F.SumAgentCharge) - F.SumConvert - G.Amount - H.Amount))
													WHEN  @tnyColumns = 5 AND  @tnySort = 1 THEN ((B.GameID * 10000) + B.ServerID)
													WHEN  @tnyColumns = 5 AND  @tnySort = 0 THEN (0 - ((B.GameID * 10000) + B.ServerID))
												END DESC) AS rowNum,
				[Id] = 0,
				B.ServerName,
				F.UserID,
				PlatformName = '',
				(F.SumCharge + F.SumAgentCharge) as SumCharge,
				F.SumConvert,
				TotalWinLose = 0,
				G.Amount,
				BankAmount = H.Amount,
				TotalGameWinLose = -((F.SumCharge+F.SumAgentCharge) - F.SumConvert - G.Amount - H.Amount), -- 累计输赢 用户赢为正数，用户输为负数 计算方式的准则按照用户来计算
				IP = F.LastLogonIPAddress,
				Location = CASE	WHEN [dbo].[Fn_GetUserNickName](F.LastLogonIPAddress) = '来自火星' THEN '未知' ELSE [dbo].[Fn_GetUserNickName](F.LastLogonIPAddress) END,
				F.CreateTime,
				A.ServerID,
				F.HDType,
				R.AreaName,
				I.WinCount,
				I.LoseCount,
				F.LastLogonTime,
				CASE 
				WHEN  C.ShortName IN ('BJL','BRNN','SGJ','LHD','HHDZ','HHNN') THEN '/Game' + C.ShortName + '/TableDetail?ServerID=' + Convert(varchar,B.ServerID) + '&TableNo=0'
				WHEN  C.ShortName IN ('BY','ZJH') THEN '/Game' + C.ShortName + '/SuperTool?ServerID=' + Convert(varchar,B.ServerID) + '&TableNo=0'
				ELSE ''
				END
				AS TableURL
				
		FROM [Game].[GameUserList] AS A WITH (NOLOCK)
			INNER JOIN [ServerInfo].[GameServerList] AS B ON A.ServerID = B.ServerID
			INNER JOIN [ServerInfo].[GameList] AS C WITH (NOLOCK) ON B.GameID = C.GameID
			INNER JOIN [Users].[UserInfo] AS F WITH (NOLOCK) ON A.UserID = F.UserID AND F.UserType <> 2
			INNER JOIN [Money].[Cash] AS G WITH (NOLOCK) ON F.UserID = G.UserID
			INNER JOIN [Money].[Bank] AS H WITH (NOLOCK) ON F.UserID = H.UserID
			LEFT JOIN [Game].[UserGameInfo] AS I WITH (NOLOCK) ON B.GameID = I.GameID AND F.UserID = I.UserID
			LEFT JOIN Area.Area as R WITH (NOLOCK) ON F.AreaID = R.AreaID
		WHERE
			ISNULL(@GameID,B.GameID) = B.GameID
			AND ISNULL(@intServerID,B.ServerID) = B.ServerID
			AND F.AreaID in (select AreaID from @Temp_AreaID)
	)
	SELECT * FROM CTE WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex


	SET @intPageCount	= ISNULL(@intPageCount,0)
	SET @TotalOnlineCount	= ISNULL(@TotalOnlineCount,0)
	SET @TotalOnlineiOSCount	= ISNULL(@TotalOnlineiOSCount,0)
	SET @TotalOnlineAndroidCount	= ISNULL(@TotalOnlineAndroidCount,0)
	SET @TotalOnlineHallCount	= ISNULL(@TotalOnlineHallCount,0)
	SET @TotalOnlineGameRoomCount	= ISNULL(@TotalOnlineGameRoomCount,0)
	SET @TotalOnlineRegCount	= ISNULL(@TotalOnlineRegCount,0)
	SET @TotalOnlineRegWeeklyCount	= ISNULL(@TotalOnlineRegWeeklyCount,0)
	SET @TotalOnlineAvgCount	= ISNULL(@TotalOnlineAvgCount,0)
	SET @TotalOnlineAvgAndRoidCount	= ISNULL(@TotalOnlineAvgAndRoidCount,0)
	SET @TotalOnlineAvgiOSCount	= ISNULL(@TotalOnlineAvgiOSCount,0)
	SET @TotalOnlineMaxCount	= ISNULL(@TotalOnlineMaxCount,0)
	SET @TotalOnlineMaxiOSCount	= ISNULL(@TotalOnlineMaxiOSCount,0)
	SET @TotalOnlineMaxAndRoidCount	= ISNULL(@TotalOnlineMaxAndRoidCount,0)
	SET @TotalOnlineGame1	= ISNULL(@TotalOnlineGame1,0)
	SET @TotalOnlineGame2	= ISNULL(@TotalOnlineGame2,0)
	SET @TotalOnlineGame3	= ISNULL(@TotalOnlineGame3,0)
	SET @TotalOnlineGame4	= ISNULL(@TotalOnlineGame4,0)
	SET @TotalOnlineGame5	= ISNULL(@TotalOnlineGame5,0)
	SET @TotalOnlineGame6	= ISNULL(@TotalOnlineGame6,0)
	SET @TotalOnlineGame7	= ISNULL(@TotalOnlineGame7,0)
	SET @TotalOnlineGame8	= ISNULL(@TotalOnlineGame8,0)
	SET @TotalOnlineGame9	= ISNULL(@TotalOnlineGame9,0)
	SET @TotalOnlineGame10	= ISNULL(@TotalOnlineGame10,0)
	SET @TotalOnlineGame11	= ISNULL(@TotalOnlineGame11,0)
	SET @TotalOnlineGame12	= ISNULL(@TotalOnlineGame12,0)
	SET @TotalOnlineGame13	= ISNULL(@TotalOnlineGame13,0)
	SET @TotalOnlineGame14	= ISNULL(@TotalOnlineGame14,0)
	SET @TotalOnlineGame15	= ISNULL(@TotalOnlineGame15,0)
	SET @TotalOnlineGame16	= ISNULL(@TotalOnlineGame16,0)
	SET @TotalOnlineGame17	= ISNULL(@TotalOnlineGame17,0)
	SET @TotalOnlineGame18	= ISNULL(@TotalOnlineGame18,0)
	SET @TotalOnlineGame19	= ISNULL(@TotalOnlineGame19,0)
	SET @TotalOnlineGame20	= ISNULL(@TotalOnlineGame20,0)
	SET @TotalOnlineGame21	= ISNULL(@TotalOnlineGame21,0)
	SET @TotalOnlineGame22	= -1 --ISNULL(@TotalOnlineGame22,0)
	SET @TotalOnlineGame23	= -1 --ISNULL(@TotalOnlineGame23,0)
	SET @TotalOnlineGame24	= ISNULL(@TotalOnlineGame24,0)
	SET @TotalOnlineGame25	= ISNULL(@TotalOnlineGame25,0)


END


