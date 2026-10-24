USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Pay_GetOrderList')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Pay_GetOrderList] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Jason
-- Create date: 2018/04/02
-- Description: 用戶管理-第三方支付管理-支付訂單查詢
-- Changelog:
--	2018/04/03	alan		增加SourceTypeID, Status改回傳原值不進行加工，調整Userlevel從userinfo.GrandID取得
--	2018/05/10	Jason		#87 依運營需求調整等級判斷
--	2018/05/25	Harry		#373 新增搜寻条件 @intGWID  移除 @chvTransData
--	2018/06/25	jason		#515 後台增加代理統計資料
--	2018/06/27	jason		聯運需求, 開放後台給第三方查詢特定平台與渠道營運資訊 新增@intAdminID
--  2019/06/15  minglung	代理充值篩選條件支付状态判断修正
--  2019/08/05  mars        代理充值判斷@intPayTypeID由99改為-1
--  2019/08/06  mars		充值金額,充值人數計算改由orderlist union Moneylog
--	2019/09/26	mars		增加檢查GWID是否為空值
--  2019/10/01	mars		增加返回Systems
--	2019/10/03	mars		關連BankCodeType
--	2019/12/25	mars		增加返回CoinAmount
--	2020/01/13	Mars		修改充值金額/充值人數/新充值金額/新充值人數由LogDB.Money.MoneyLog改取CenterDB.Pay.OrderList #62
--  2020/02/14	Louis		修改傳入時間參數查詢，讓彙整數值跟清單內容一致
--  2020/02/27	Mars		修正新增兑换金额未加絕對值及多*100
-- 	2020/03/09 	Mars 		刪除原先選擇篩選支付類型, 總充值金額就以orderlist數據加總
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Pay_GetOrderList]
(
	@intAdminID		INT,
	@intPlatformID	INT = NULL,
	@intAreaID		INT = NULL,
	@dtStartTime		DATETIME = NULL,
	@dtEndTime		DATETIME = NULL,
	@dtStartLastUpdateTime		DATETIME = NULL,
	@dtEndLastUpdateTime		DATETIME = NULL,
	@chvUserName	VARCHAR(32) = NULL,
	@intUserID		INT = NULL,
	@tnyStatus		TINYINT = NULL,
	@intOrderID		INT = NULL,
	@chvIPAddress	VARCHAR(15) = NULL,
	@intPayTypeID	INT = NULL,
	@intGWID        INT = NULL,
	@intPageIndex	INT	= 1,
	@intPageSize	INT = 20,
	@intPageCount	INT = 0			OUTPUT,
	@intTotalChargeAmount BIGINT = 0	OUTPUT, --充值金额
	@intTotalConvertAmount	BIGINT = 0	OUTPUT, --兑换金额
	@intTotalChargeUser BIGINT = 0	OUTPUT, --充值人数
	@intTotalConvertUser BIGINT = 0	OUTPUT, --兑换人数
	@intNewTotalChargeAmount BIGINT = 0	OUTPUT, --新增充值金额
	@intNewTotalConvertAmount	BIGINT = 0	OUTPUT, --新增兑换金额
	@intNewTotalChargeUser BIGINT = 0	OUTPUT, --新增充值人数
	@intNewTotalConvertUser BIGINT = 0	OUTPUT  --新增兑换人数
)
AS
BEGIN

	SET NOCOUNT ON

	--判斷是否還有GWID為空
	EXEC dbo.PrPs_Payment_CheckPayOrderListGWID

	DECLARE @PlatformID INT = @intPlatformID		--平台
	DECLARE @AreaID INT = @intAreaID				--渠道
	DECLARE @UserName VARCHAR(32)= @chvUserName		--帳號
	DECLARE @UserID INT = @intUserID				--用戶ID
	DECLARE @Status TINYINT = @tnyStatus			--訂單狀態
	DECLARE @OrderID INT = @intOrderID				--編號
	DECLARE @IPAddress VARCHAR(15) = @chvIPAddress	--IP地址
	DECLARE @GWID INT = @intGWID                    --第三方厂商
	DECLARE @PayTypeID INT = @intPayTypeID			--支付類型

	CREATE TABLE #Temp_PlatformID ([PlatformID] INT Primary KEY)
	CREATE TABLE #Temp_AreaID ([AreaID] INT Primary KEY)

	--筛选平台
	INSERT INTO #Temp_PlatformID
	SELECT DISTINCT [PlatformID]
	FROM [dbo].[Fn_GetPlatformAccessList](@intAdminID)
	WHERE ISNULL(@intPlatformID,[PlatformID]) = [PlatformID]

	--筛选渠道
	INSERT INTO #Temp_AreaID 
	SELECT [AreaID] 
	FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	WHERE ISNULL(@intPlatformID, [PlatformID]) = [PlatformID] 
	AND ISNULL(@intAreaID, [AreaID]) = [AreaID] 

	--充值金額,充值人數
	--新增充值金額,新增充值人數
	SELECT @intTotalChargeAmount = ISNULL(SUM(T1.[ChargeAmount]),0), 
			@intTotalChargeUser = COUNT(DISTINCT T1.[ChargeUser]),
			@intNewTotalChargeAmount = ISNULL(SUM(T1.[NewChargeAmount]),0), 
			@intNewTotalChargeUser = COUNT(DISTINCT T1.[NewTotalChargeUser])
	FROM 
	(
		SELECT (ISNULL(O.[Amount], 0) * 100) as [ChargeAmount]
		,O.[UserID] as [ChargeUser]
		,CASE WHEN U.[CreateTime] > ISNULL(@dtStartTime,@dtStartLastUpdateTime) THEN (ISNULL(O.[Amount], 0) * 100) ELSE 0 END AS [NewChargeAmount]
		,CASE WHEN U.[CreateTime] > ISNULL(@dtStartTime,@dtStartLastUpdateTime) THEN O.[UserID] ELSE NULL END AS [NewTotalChargeUser]
		FROM [CenterDB].[Pay].[OrderList] AS O WITH (NOLOCK)
		JOIN [CenterDB].[Users].[UserInfo] AS U ON O.[UserID] = U.[UserID] 
		JOIN [CenterDB].[Area].[Area] AS A ON A.[AreaID] = U.[AreaID]  
		WHERE (@dtStartTime IS NULL OR O.[CreateTime] >= @dtStartTime) 
		AND (@dtEndTime IS NULL OR O.[CreateTime] < @dtEndTime)
		AND (@dtStartLastUpdateTime IS NULL OR O.[LastUpdateTime] >= @dtStartLastUpdateTime) 
		AND (@dtEndLastUpdateTime IS NULL OR O.[LastUpdateTime] >= @dtEndLastUpdateTime)
		AND O.[Status] = 2
		AND A.[AreaID] IN (SELECT [AreaID] FROM #Temp_AreaID) 
	) AS T1

	--兌換金額,兌換充值人數
	--新增兌換金額,新增兌換充值人數
	SELECT @intTotalConvertAmount = ISNULL(SUM(ABS(C.[Amount])) ,0)
	,@intTotalConvertUser = COUNT(DISTINCT C.[UserID])
	,@intNewTotalConvertAmount = ISNULL(SUM(CASE WHEN U.[CreateTime] > ISNULL(@dtStartTime,@dtStartLastUpdateTime) THEN ISNULL(ABS(C.[Amount]), 0) ELSE 0 END),0)
	,@intNewTotalConvertUser = COUNT(DISTINCT CASE WHEN U.[CreateTime] > ISNULL(@dtStartTime,@dtStartLastUpdateTime) THEN C.[UserID] ELSE NULL END) 
	FROM [logdb].[Money].[ConvertLog] AS C WITH (NOLOCK) 
	LEFT JOIN Users.UserInfo AS U WITH (NOLOCK) ON C.[UserID] = U.[UserID]
	WHERE (@dtStartTime IS NULL OR C.[CreateTime] >= @dtStartTime) 
	AND (@dtEndTime IS NULL OR C.[CreateTime] < @dtEndTime)
	AND (@dtStartLastUpdateTime IS NULL OR C.[LastUpdateTime] >= @dtStartLastUpdateTime) 
	AND (@dtEndLastUpdateTime IS NULL OR C.[LastUpdateTime] >= @dtEndLastUpdateTime)
	AND C.[Status] = 3
	AND C.[AreaID] IN (SELECT [AreaID] FROM #Temp_AreaID)
	AND C.[PlatformID] IN (SELECT [PlatformID] FROM #Temp_PlatformID)
	
	--暫存數據料表
	SELECT * 
	INTO #tmp_stat
	FROM (SELECT C.[PlatformID],
				E.[Name] AS PlatformName,
				C.[AreaID],
				A.[CreateTime],
				A.[LastUpdateTime],
				A.[Id] AS [OrderID],
				A.[GWID],
				A.[PayTypeID],
				PG.[GatewayName] AS [GatewayName],
				ISNULL(PB.[BankName], PT.[BankCode]) AS TypeName,
				PT.[ID] AS [SourceTypeID],
				A.[UserID],
				B.[LoginName],
				B.[GradeID] AS [UserLevel], 
				A.[Amount],
				A.[CoinAmount],
				A.[Status],
				A.[IPAddress],
				A.[TransID],
				A.[TransData],
				A.[ClaimAmount],  --客服補單金額
				B.[CreateTime] AS [UserCreateTime],
				[Systems]
		FROM [CenterDB].[Pay].[OrderList] AS A WITH (NOLOCK)
		LEFT JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.[UserID] = B.[UserID]
		LEFT JOIN [Area].[Area] AS C WITH (NOLOCK) ON B.[AreaID] = C.[AreaID]
		LEFT JOIN [Area].[Platform] AS E WITH (NOLOCK) ON C.[PlatformID] = E.[PlatformID]
		LEFT JOIN [Payment].[PayType] AS PT WITH (NOLOCK) ON A.[PayTypeID] = PT.[ID]
		LEFT JOIN [Payment].[BankCodeType] AS PB WITH (NOLOCK) ON PB.[BankCode] = PT.[BankCode]
		LEFT JOIN [Payment].[PayGateway] AS PG WITH (NOLOCK) ON PT.[GWID] = PG.[ID]
		--LEFT JOIN [Pay].[PayType] AS D WITH (NOLOCK) ON A.GWID = D.GWID AND A.PayTypeID = D.TypeID
		--LEFT JOIN [Pay].[PayGateway] AS F WITH (NOLOCK) ON D.GWID = F.ID
		WHERE (@dtStartTime IS NULL OR A.[CreateTime] >= @dtStartTime) 
		AND (@dtEndTime IS NULL OR A.[CreateTime] < @dtEndTime)
		AND (@dtStartLastUpdateTime IS NULL OR A.[LastUpdateTime] >= @dtStartLastUpdateTime) 
		AND (@dtEndLastUpdateTime IS NULL OR A.[LastUpdateTime] >= @dtEndLastUpdateTime)	
		AND (@dtStartLastUpdateTime IS NULL OR A.LastUpdateTime >= @dtStartLastUpdateTime)
		AND (@dtEndLastUpdateTime IS NULL OR A.LastUpdateTime < @dtEndLastUpdateTime)
		AND (@UserName IS NULL OR B.[LoginName] = @UserName)
		AND (@UserID IS NULL OR A.[UserID] = @UserID)
		AND (@Status IS NULL OR A.[Status] = @Status)
		AND (@OrderID IS NULL OR A.[Id] = @OrderID)
		AND (@IPAddress IS NULL OR A.[IPAddress] = @IPAddress)
		AND (@PayTypeID IS NULL OR A.[PayTypeID] = @PayTypeID)
		AND (@GWID IS NULL OR A.[GWID] = @GWID)
		AND (A.[GWID] IS NOT NULL OR PT.[GWID] IS NOT NULL)
		AND C.[AreaID] IN (SELECT [AreaID] FROM #Temp_AreaID)
		AND C.[PlatformID] IN (SELECT [PlatformID] FROM #Temp_PlatformID)
		UNION ALL

		--官方代理充值记录
		SELECT	a.PlatformID,
				E.Name AS PlatformName,
				a.AreaID,
				a.[CreateTime],
				a.CreateTime AS LastUpdateTime,
				OrderID = a.logid,
				0 AS GWID,
				99 AS PayTypeID,
				'代理支付' as GatewayName,
				'已支付' as TypeName,
				a.[SourceTypeID],
				a.[UserID],
				b.LoginName,
				UserLevel = B.GradeID,
				Amount = [UpdateAmount] / 100,
				UpdateAmount AS CoinAmount,
				2 AS [Status],
				a.[IPAddress],
				'' AS TransID,
				A.Memo AS TransData,
				0 AS ClaimAmount,  --客服補單金額,
				B.CreateTime AS UserCreateTime,
				0 AS Systems 
		FROM [LogDB].[Money].[MoneyLog] as a WITH (NOLOCK)
		LEFT JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.UserID = B.UserID
		LEFT JOIN [Area].[Area] AS C WITH (NOLOCK) ON B.AreaID = C.AreaID
		LEFT JOIN [Area].[Platform] AS E WITH (NOLOCK) ON C.PlatformID = E.PlatformID
		INNER JOIN #Temp_PlatformID AS Z ON C.PlatformID = Z.PlatformID
		WHERE 
		CASE WHEN isnull(@PayTypeID,-1) = -1 THEN 11008 ELSE 0 END = SourceTypeID
			AND (@AreaID IS NULL OR a.AreaID = @AreaID)
			AND (@dtStartTime IS NULL OR a.CreateTime >= @dtStartTime)
			AND (@dtEndTime IS NULL OR a.CreateTime < @dtEndTime)
			AND (@dtStartLastUpdateTime IS NULL OR A.CreateTime >= @dtStartLastUpdateTime)
			AND (@dtEndLastUpdateTime IS NULL OR A.CreateTime < @dtEndLastUpdateTime)

			AND (@UserName IS NULL OR LoginName = @UserName)
			AND (@UserID IS NULL OR a.UserID = @UserID)
			AND (@OrderID IS NULL OR A.logId = @OrderID)
			AND (@IPAddress IS NULL OR [IPAddress] = @IPAddress)
			AND a.AreaID IN (SELECT AreaID FROM #Temp_AreaID)
			AND (@GWID IS NULL OR @GWID=-1) --如果有篩選第三方, 則不顯示官方代理充值
			AND (@Status is null or @Status = 2) --篩選條件如果是支付成功(=2)才顯代理
	) as a
	------------------------
	--取得頁數
	SELECT	@intPageCount = COUNT(1) from #tmp_stat

	;WITH CTE AS
	(
		SELECT	
			ROW_NUMBER() OVER (	
				Order by Case 
				When @dtStartTime is null Then LastUpdateTime 
				When @dtStartLastUpdateTime is null Then CreateTime 
			END DESC) AS rowNum,
			PlatformID,
			PlatformName,
			AreaID,
			CreateTime,
			LastUpdateTime,
			OrderID,
			GWID,
			PayTypeID,
			GatewayName,
			TypeName,
			SourceTypeID,
			UserID,
			LoginName,
			UserLevel,
			Amount,
			CoinAmount,
			[Status],
			[IPAddress],
			TransID,
			TransData,
			ClaimAmount,
			Systems
		FROM #tmp_stat
	)

	SELECT * 
	FROM CTE 
	WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex

	DROP TABLE #tmp_stat
	DROP TABLE #Temp_PlatformID
	DROP TABLE #Temp_AreaID
END