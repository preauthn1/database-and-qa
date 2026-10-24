-- =============================================
-- Author:		Jason
-- Create date: 2019/05/24
-- Description:	Slot 取遊戲歷程
-- =============================================
-- =============================================
-- Author:		Jason
-- Create date: 2019/05/24
-- Description:	Slot 取遊戲歷程
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Slot_GetGameLog]
(
	@intUserID			INT,
	@intGameID			INT,
	@dtStartTime		DATETIME = NULL,
	@dtEndTime			DATETIME = NULL,
	@intPageIndex		INT	= 1,
	@intPageSize		INT = 20,
	@intPageCount		INT = 0			OUTPUT,
	@chvMsg				VARCHAR(100)	OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON


	DECLARE @StartTime	DATETIME = ISNULL(@dtStartTime,GETDATE()-7)
	DECLARE @EndTime	DATETIME = ISNULL(DATEADD(DAY,1,@dtEndTime),GETDATE()+1)


	SELECT	@intPageCount = COUNT(1)
	FROM [Game].[SlotGameHistoryLog] WITH (NOLOCK)
	WHERE
		[UserID] = @intUserID
		AND [GameID] = @intGameID
		AND [CreateTime] >= @StartTime
		AND [CreateTime] < @EndTime


	;WITH CTE
	AS (
			SELECT	ROW_NUMBER() OVER (ORDER BY [LogID] ASC) AS rowNum,
					[UserID] = @intUserID,
					[CreateTime],
					[OrderID] = [LogID],
					[BetMoney] = ISNULL([BetMoney],0) + ISNULL([BetCoupon],0),
					[FinalScore] = (ISNULL([FinalScore],0) - ISNULL([CurrentAmount],0)) + (ISNULL([FinalCoupon],0) - ISNULL([CurrentCoupon],0))
			FROM [Game].[SlotGameHistoryLog] WITH (NOLOCK)
			WHERE
				[UserID] = @intUserID
				AND [GameID] = @intGameID
				AND [CreateTime] >= @StartTime
				AND [CreateTime] < @EndTime
		)
	SELECT * FROM CTE WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex
	ORDER BY rowNum ASC

	SET @chvMsg	= '完成'
	RETURN 1
END
