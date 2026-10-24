-- =============================================
-- Author:  mars
-- Create date: 2019/08/14
-- Description: 後台取得玩家稽核流水紀錄

--	2019-10-25		Marshall		新增status篩選、新增3-4個欄位查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Event_GetContestUserFlowLimit]
(
	@intUserID INT,
	@dtStartTime DATETIME = null,
	@dtEndTime DATETIME = null,
	@intStatus INT = null,
	@intPageIndex INT = 1,
	@intPageSize INT = 50,
	@intPageCount INT = 0 OUTPUT
)
AS
BEGIN
	DECLARE @LastUpdateTime DATETIME,  --最後一次撥款時間
			@SumFlowAmount INT,
			@LastConvertFlowAmount INT,
			@FlowAmountLimit INT

	--撈最後一次撥款時間
	SELECT TOP 1 @LastUpdateTime = LastUpdateTime 
	FROM LogDB.money.ConvertLog 
	WHERE userID = @intUserID and status = 3
	ORDER BY id DESC

	--
	SELECT @SumFlowAmount = SumFlowAmount, @LastConvertFlowAmount = LastConvertFlowAmount
	FROM Users.Userinfo 
	WHERE UserID = @intUserID;


	SELECT F.UserID,
			F.Type,
			F.SourceTypeID, 
			F.EventID,
			EventName = CASE WHEN F.Type = 1 
			THEN 
				S.SourceName
			ELSE 
				CASE WHEN F.Type = 2 
				THEN
					E.EventName
				ELSE
					''
				END
			END,
			FlowAmount = F.FlowLimit,
			F.Amount,			--存款金額
			F.SumFlowAmount,	--當下總輸贏流水
			F.FlowAmountLimit,	--稽核流水
			F.FlowLimit,		--總輸贏流水需達此標
			F.CreateTime,
			F.StartTime,
			F.EndTime,
			F.Id,
			F.Memo,
			F.UpdateBy,
			F.UpdateTime,
			F.Status
	INTO #T
	FROM Event.FlowAmountLimitLog AS F
	LEFT JOIN Stat.MoneySourceType AS S ON S.SourceID = F.SourceTypeID 
	LEFT JOIN Club02.dbo.EventInfo AS E ON E.EventID = F.EventID
	WHERE F.UserID = @intUserID
		AND (@dtStartTime is null or F.CreateTime >= @dtStartTime)
		AND (@dtEndTime is null or F.CreateTime <= @dtEndTime)
		AND (@intStatus is null or F.Status = @intStatus)

	ORDER BY F.CreateTime DESC


	--------------------------------------------------------------------------------
	SELECT	@intPageCount = COUNT(1)
	FROM (
			SELECT * FROM #T WITH (NOLOCK)
	) AS A
	;WITH CTE
	AS (
		SELECT ROW_NUMBER() OVER (ORDER BY A.CreateTime DESC) AS rowNum, *
		FROM (
				SELECT T.* FROM #T AS T
			) AS A
	)
	
	SELECT * FROM CTE WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex
END