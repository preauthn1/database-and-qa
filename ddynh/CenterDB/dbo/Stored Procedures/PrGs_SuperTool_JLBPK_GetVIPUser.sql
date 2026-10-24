

-- =============================================
-- Author:  alan
-- Create date: 20180903
-- Description:	加勒比海撲克 - 取得監控名單
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_SuperTool_JLBPK_GetVIPUser]
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @dtStart DATETIME = DATEADD(DAY,0,DATEDIFF(DAY,0,GETDATE()))
	DECLARE @dtEnd DATETIME = DATEADD(DAY,1,@dtStart)

	--監控用戶
	SELECT UserID INTO #vipuser FROM CenterDB.[Game].[SuperTool_JLBPK_VIPUser] WITH (NOLOCK)

	--今天充直與兌換
	SELECT yyyymmdd, userid, 
			SUM(SumCharge) as TodaySumcharge, 
			SUM(-SumConvert) as TodaySumConvert, 
			SUM(SumCharge)- SUM(-SumConvert) as TodayUserWinLose 
	INTO #TodayUserinfo
	FROM
	(
		SELECT CONVERT(VARCHAR, @dtStart,112) AS yyyymmdd, UserID, SUM(UpdateAmount) AS SumCharge, 0 AS SumConvert 
		FROM logdb.[Money].[MoneyLog] WITH (NOLOCK)
		WHERE SourceTypeID BETWEEN 11001 AND 11098 
		AND CreateTime >= @dtStart AND CreateTime < @dtEnd
		AND UserID IN (SELECT UserID FROM #vipuser)
		GROUP BY UserID
		UNION
		SELECT Convert(VARCHAR,@dtStart,112) AS yyyymmdd, UserID, 0 AS SumCharge, SUM(Amount) AS SumConvert 
		FROM logdb.Money.ConvertLog WITH (NOLOCK)
		WHERE CreateTime >= @dtStart AND CreateTime < @dtEnd 
		AND UserID in (SELECT UserID FROM #vipuser)
		GROUP BY UserID
	) AS a
	GROUP BY yyyymmdd, userid

	SELECT 
	J.UserID,
	ISNULL(J.UserWeight, 0) as UserWeight,
	ISNULL(J.TargetMoney, 0) as TargetMoney,
	ISNULL(J.AccumulatedMoney, 0) as AccumulatedMoney,
	ISNULL(J.Finish,0) as Finish,
	Z.Status,
	J.Operator,
	ISNULL(U.TodaySumcharge,0) AS TodaySumcharge,
	ISNULL(U.TodaySumConvert,0) AS TodaySumConvert,
	ISNULL(U.TodayUserWinLose,0) AS TodayUserWinLose 
	FROM Game.SuperTool_JLBPK_VIPUser J WITH (NOLOCK)
	LEFT JOIN #TodayUserinfo U WITH (NOLOCK)
	ON J.UserID = U.UserID

	RETURN 1
END