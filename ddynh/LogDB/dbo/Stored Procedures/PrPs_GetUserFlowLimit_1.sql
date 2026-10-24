
-- =============================================
-- Author:		Mars
-- Create date: 2019/10/28
-- Description:	回傳流水相關訊息
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_GetUserFlowLimit]
(
	@intUserID INT,
	@intDayFlowAmount INT OUTPUT,
	@intSevenDayFlowAmount INT OUTPUT,
	@intMonthFlowAmount INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @dtNow DATETIME = GETDATE(),
	        @dtFirstDayOfTheMonth DATETIME,
	        @dtStartDay DATETIME,
	        @intDays INT = 0,
	        @SevenDay DATETIME
	DECLARE @tmp TABLE(EventDate DATETIME, FlowAmount INT)
	--取得七天前的日期
	SET @SevenDay = DATEADD(day, -7, @dtNow)
	--取得當月第一天
	SET @dtFirstDayOfTheMonth = DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0)
	SET @dtStartDay = @dtFirstDayOfTheMonth
	--當今天與當月第一天的相差天數小於7天時,
	IF (@dtFirstDayOfTheMonth > @SevenDay)
	BEGIN
	    set @dtStartDay = @SevenDay
	END
	INSERT INTO @tmp
	SELECT CONVERT(CHAR(8), CreateTime, 112) as EventDate, sum(FlowAmount) as FlowAmount
	FROM LogDB.Money.MoneyLog WITH (NOLOCK)
	WHERE sourceTypeID < 10000
	    AND userid = @intUserID
	    AND CreateTime BETWEEN @dtStartDay AND @dtNow
	GROUP BY CONVERT(CHAR(8), CreateTime, 112)
	--當天
	SELECT @intDayFlowAmount = SUM(FlowAmount)  FROM @tmp WHERE EventDate = CONVERT(CHAR(8), @dtNow, 112)
	--七天
	SELECT @intSevenDayFlowAmount = SUM(FlowAmount)  FROM @tmp WHERE EventDate BETWEEN CONVERT(CHAR(8), @SevenDay, 112) AND CONVERT(CHAR(8), @dtNow, 112)
	--當月
	SELECT @intMonthFlowAmount = SUM(FlowAmount) FROM @tmp WHERE EventDate BETWEEN CONVERT(CHAR(8), @dtFirstDayOfTheMonth, 112) AND CONVERT(CHAR(8), @dtNow, 112)
END