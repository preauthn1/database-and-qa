-- =============================================
-- Author:  jason
-- Create date: <保險箱流向統計>
-- Description:	<金幣流向統計>  原作法是ORM取資料表資料顯示 新增PlatformID AreaID 對應 寫到新的[Stat].[StatisticsBankSourceLog_New]
-- 2019/09/26	Mars		回傳加上ChangeTypeID 並移除掉計算總流入及總流出的部份
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetBankSourceLog_New]
	@intAdminID	int,	
	@intPlatformID	INT=NULL,
	@intAreaID		INT=NULL,
	@intSourceType	INT=NULL,			--0:全部 12000:C存款 12001:Q取款 13000:G管理員增加保險箱金幣
										--13001:G管理員減少保險箱金幣 13002:G管理員風所用互扣保險箱金幣 13003:G管理員解鎖用戶還原保險箱金幣
	@intChangeType	INT=NULL,			--0:全部 1:流出 2:流通 3:流入
	@dtBeginTime	DATETIME=NULL,		--开始时间范围
	@dtEndTime		DATETIME=NULL		--结束时间范围
AS
BEGIN

	SET NOCOUNT ON

	--平台篩選
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	INSERT INTO @Temp_PlatformID Select PlatformID From CenterDB.Area.PlatformAdminUser where AdminID=@intAdminId


	DECLARE @BeginTime	DATETIME = ISNULL(@dtBeginTime,'1900-01-01 00:00:00.000')
	DECLARE @EndTime	DATETIME = ISNULL(@dtEndTime,'2100-01-01 00:00:00.000')
	
	DECLARE @Total_In		BIGINT
	DECLARE @Total_Out		BIGINT
	DECLARE @Total_Dual		BIGINT
	DECLARE @Total_String	VARCHAR(100)

	SET @intSourceType = ISNULL(@intSourceType,0)

	SET @intChangeType = CASE	WHEN @intChangeType IS NULL OR @intChangeType = 0 THEN 999
								WHEN @intChangeType = 3 THEN 0
							ELSE @intChangeType END

	DECLARE @Temp_Total_New TABLE
			([StatTime] VARCHAR(10),[PlatformID] VARCHAR(32),[AreaID] VARCHAR(32),[SourceID] VARCHAR(32),[SourceName] VARCHAR(32),
			[ChangeType] TINYINT,[Amount] BIGINT)

	/*  新作法 必須帶入PlatformID and AreaID  */
		INSERT INTO @Temp_Total_New
		SELECT	[StatTime] = CONVERT(VARCHAR(10),[StatTime],23),
				[PlatformID] = CAST(A.[PlatformID] AS VARCHAR(32)),
				[AreaID] = CAST(A.[AreaID] AS VARCHAR(32)),
				[SourceID] = CAST(A.[SourceID] AS VARCHAR(32)),
				[SourceName],
				[ChangeType],
				[Amount] = [Amount]
		FROM [Stat].[BankSourceLog_New] AS A WITH (NOLOCK)
			INNER JOIN [Stat].[BankSourceType] AS B WITH (NOLOCK) ON A.SourceID = B.SourceID
		WHERE 
			([StatTime] >= @BeginTime)
			AND ([StatTime] <= @dtEndTime)
			AND (@intPlatformID is null or [PlatformID] = @intPlatformID)
			AND (@intAreaID is null or [AreaID] = @intAreaID)
			AND (A.[SourceID] = @intSourceType OR @intSourceType = 0)
			AND ([ChangeType] = @intChangeType OR @intChangeType = 999)
			AND PlatformID in (select platformid from @Temp_PlatformID)

		SELECT	[StatTime],
				[PlatformID],
				[AreaID],
				[SourceID],
				[SourceName],
				[ChangeType],
				[Amount]
		FROM @Temp_Total_New
		--UNION ALL
		--SELECT '','','','','','',@Total_String
	--END
	--------------------------------------------------------------------------------------------------------------------
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetBankSourceLog_New] TO [GameUser]
    AS [dbo];

