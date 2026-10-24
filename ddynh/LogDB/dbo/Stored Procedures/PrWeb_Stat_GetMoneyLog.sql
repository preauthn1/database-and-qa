-- =============================================
-- Author:  Jason
-- Create date: 2018/04/10
-- Description:	查询用户现金记录 (機制改寫)

--	2018/04/27	Jason		新增回傳TradeID
--	2019/09/11	Marshall	新增參數AdminUserID
--	2019/09/25	Amy			新增OUTPUT 记录流水总数

-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetMoneyLog]
(
	@intUserID			INT = NULL,
	@intSourceTypeGroup	INT = NULL,
	@intSourceType		INT = NULL,
	@chvIPAddress		VARCHAR(15) = NULL,
	@chvMemo			VARCHAR(128) = NULL,
	@beginTime			DATETIME = NULL,
	@endTime			DATETIME = NULL,
	@intAreaID			INT = NULL,
	@intPlatformID		INT = NULL,
	@intPageIndex		INT = 1,
	@intPageSize		INT = 20,
	@intAdminUserID		INT = NULL,  --若有填寫代表要只看查該用戶所屬的平台
	@intSumFlowAmount	BIGINT = 0		OUTPUT,		--记录流水总数
	@intPageCount		INT				OUTPUT	--记录总数		
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @UserID				INT = @intUserID
	DECLARE @SourceTypeGroup	INT = @intSourceTypeGroup
	DECLARE @SourceType			INT = @intSourceType
	DECLARE @IPAddress			VARCHAR(40) = @chvIPAddress
	DECLARE @LogStatTime		DATETIME = @beginTime
	DECLARE @LogEndTime			DATETIME = @endTime
	DECLARE @AreaID				INT = @intAreaID


	
	DECLARE @myOwnAreaIDs table (AreaID int)
	INSERT INTO @myOwnAreaIDs 
	Select AreaID 
	FROM [CenterDB].[Area].[AreaAdminUser]
	WHERE AdminID = @intAdminUserID


	SELECT 
		@intPageCount = COUNT(1),
		@intSumFlowAmount = SUM(FlowAmount)
	FROM [Money].[MoneyLog] AS A WITH (NOLOCK)
	WHERE
		A.[SourceTypeID] = ISNULL(@SourceType,A.[SourceTypeID])
		AND A.UserID = ISNULL(@UserID,A.UserID)
		AND A.IPAddress = ISNULL(@IPAddress,A.IPAddress)
		AND A.CreateTime >= ISNULL(@LogStatTime,A.CreateTime)
		AND A.CreateTime <= ISNULL(@LogEndTime,A.CreateTime)
		AND A.AreaID = ISNULL(@AreaID,A.AreaID)
		AND A.PlatformID = ISNULL(@intPlatformID,A.PlatformID)
		AND (@intAdminUserID is NULL OR A.AreaID in (SELECT AreaID FROM @myOwnAreaIDs))

	;WITH CTE AS
	(
		SELECT	ROW_NUMBER() OVER (ORDER BY A.CreateTime DESC) AS rowNum,
				A.[LogID],
				A.[UserID],
				A.[SourceTypeID],
				A.[CurrentAmount],
				A.[UpdateAmount],
				A.[TaxAmount],
				A.[IPAddress],
				A.[Memo],
				A.[CreateTime],
				A.[AreaID],
				A.[PlatformID],
				A.[TradeID],
				A.[FlowAmount]
		FROM [Money].[MoneyLog] AS A WITH (NOLOCK)
		WHERE
			A.[SourceTypeID] = ISNULL(@SourceType,A.[SourceTypeID])
			AND A.UserID = ISNULL(@UserID,A.UserID)
			AND A.IPAddress = ISNULL(@IPAddress,A.IPAddress)
			AND A.CreateTime >= ISNULL(@LogStatTime,A.CreateTime)
			AND A.CreateTime <= ISNULL(@LogEndTime,A.CreateTime)
			AND A.AreaID = ISNULL(@AreaID,A.AreaID)
			AND A.PlatformID = ISNULL(@intPlatformID,A.PlatformID)
			AND (@intAdminUserID is NULL OR A.AreaID in (SELECT AreaID FROM @myOwnAreaIDs))
	)
	SELECT * FROM CTE WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex	
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetMoneyLog] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetMoneyLog] TO [xbuser]
    AS [dbo];

