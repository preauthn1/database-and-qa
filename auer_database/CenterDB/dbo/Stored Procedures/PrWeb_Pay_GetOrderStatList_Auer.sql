
-- =============================================
-- Author:  Eddie
-- Create date: 2019/11/21
-- Description: 用戶管理-第三方支付管理-支付渠道報表
-- Changelog:
--	2019/11/21	Eddie		調整對應Auer後台
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Pay_GetOrderStatList_Auer]
(
	@intAdminId		INT,
	@intPlatformID	INT = NULL,
	@intAreaID		INT = NULL,
	@dtStatTime		DATETIME = NULL,
	@dtEndTime		DATETIME = NULL,
	@intPayTypeID	INT = NULL,			--0 全部 1 支付宝 2 微信支付 3 银行卡充值 4 QQ支付
	@intPageIndex	INT	= 1,
	@intPageSize	INT = 20,
	@intPageCount	INT = 0		OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @PlatformID INT = @intPlatformID		--平台
	DECLARE @AreaID INT = @intAreaID				--渠道
	DECLARE @StatTime DATETIME = @dtStatTime		--開始日期
	DECLARE @EndTime DATETIME = @dtEndTime			--結束日期
	DECLARE @PayTypeID INT = @intPayTypeID			--支付類型

	DECLARE @yesStatTime datetime --昨日開始日期
	DECLARE @yesEndTime datetime --昨日結束日期
	SET @yesStatTime = CAST(Convert(varchar,DATEAdd(day,-1,GETDATE()),110) as DATETIME)
	SET @yesEndTime = GETDATE()-1

	--今日
	DECLARE @TotalCharge	BIGINT --支付總金額
	DECLARE @TotalPointAmount	BIGINT --充值金幣總額
	DECLARE @Chargeusers int	--充值用户去重
	DECLARE @TotalCount	BIGINT --訂單總數
	DECLARE @SuccessCount	BIGINT --成功訂單數
	DECLARE @FailCount	BIGINT --失敗訂單數
	DECLARE @SuccessRate	FLOAT --成功率

	--昨日
	DECLARE @yesTotalCharge	BIGINT --充值總額
	DECLARE @yesTotalPointAmount	BIGINT --充值金幣總額
	DECLARE @yesChargeusers int	--充值用户去重
	DECLARE @yesTotalCount	BIGINT --訂單總數
	DECLARE @yesSuccessCount	BIGINT --成功訂單數
	DECLARE @yesFailCount	BIGINT --失敗訂單數
	DECLARE @yesSuccessRate	FLOAT --成功率

	DECLARE @HeadLineJson	VARCHAR(MAX)

	DECLARE @Temp_PayType	TABLE (GWID INT,PayTypeID INT,GatewayName VARCHAR(100),TypeName VARCHAR(100))
	DECLARE @Temp_STAT	TABLE (PayTypeID int, GatewayName VARCHAR(100),TypeName VARCHAR(100),TotalAmount Bigint, TotalPointAmount Bigint, TotalCount int, SuccessCount int, SuccessRate FLOAT)
	

	--渠道篩選
	DECLARE @Temp_AreaID TABLE (AreaID	INT)
	INSERT INTO @Temp_AreaID Select AreaID From Area.AreaAdminUser where AdminID=@intAdminID


	--取得所有支付與渠道對應表
	INSERT INTO @Temp_PayType
	SELECT P.GWID,P.TypeID,G.GatewayName,P.TypeName FROM [CenterDB].[Pay].[PayType] as P
	  left join 
	  pay.paygateway as G
	  on p.GWID = G.ID
 

	--計算每個支付渠道的筆數與成功率
	;WITH CTE2 AS
	(
			SELECT 
			a.gwid,
			a.PayTypeID, 
			SUM(CASE WHEN A.Status=2 Then A.Amount ELSE 0 END) as TotalAmount,
			SUM(CASE WHEN A.Status=2 Then A.PointAmount ELSE 0 END) as TotalPointAmount,
			count(id) as TotalCount,
			SuccessCount = SUM(CASE	WHEN A.Status=2 THEN 1 ELSE 0 END),
			SuccessRate = CAST(  (SUM(CASE WHEN A.Status=2 THEN 1 ELSE 0 END) * 1.00 / COUNT(id))* 100 AS Decimal(18,2)   )
			from 
			[CenterDB].[Pay].[OrderList] AS A WITH (NOLOCK) 
			left join pay.[PayType] as b with (nolock)
			on a.gwid = b.GWID and a.PayTypeID = b.TypeID
			left join Users.UserInfo as U with (nolock) on U.UserID=A.UserID
			where 
			(@StatTime IS NULL OR A.CreateTime >= @StatTime)
			AND (@EndTime IS NULL OR A.CreateTime < @EndTime)
			AND a.gwid is not null
			AND U.AreaID in (select AreaID from @Temp_AreaID)
			group by a.gwid,a.PayTypeID
	)
	Insert @Temp_STAT
	Select T.PayTypeID, T.GatewayName,T.TypeName,ISNULL(C.TotalAmount,0) as TotalAmount,ISNULL(C.TotalPointAmount,0) as TotalPointAmount,ISNULL(C.TotalCount,0) as TotalCount,ISNULL(C.SuccessCount,0) as SuccessCount ,ISNULL(C.SuccessRate,0) as SuccessRate from 
	@Temp_PayType  AS T
	full join
	CTE2 as C	
	on 
	C.GWID = T.GWID AND C.PayTypeID = T.PayTypeID 


	SELECT	@intPageCount = COUNT(1)
	FROM @Temp_STAT


	/*  統計部分另外計算  */
	/*  今日數字  */
	------------------------------------------------------------------------------------------
	--計算所有的總付費與成功率
	SELECT	@TotalCharge = SUM(CASE WHEN A.Status=2 Then A.Amount ELSE 0 END),
			@TotalPointAmount = SUM(CASE WHEN A.Status=2 Then A.PointAmount ELSE 0 END),
			@TotalCount = Count(ID),
			@SuccessCount = SUM(CASE WHEN A.Status=2 THEN 1 ELSE 0 END),
			@FailCount = SUM(CASE WHEN A.Status in (1,3) THEN 1 ELSE 0 END),
			@SuccessRate =  CAST(  @SuccessCount*1.0 / (@FailCount + @SuccessCount) * 100 AS Decimal(18,2) ),
			@Chargeusers = IsNull(count(distinct (CASE WHEN A.Status=2 Then A.UserID ELSE NULL END)),0)

	FROM [CenterDB].[Pay].[OrderList] AS A WITH (NOLOCK)
		LEFT JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.UserID = B.UserID and UserType <> 2
		LEFT JOIN [Area].[Area] AS C WITH (NOLOCK) ON B.AreaID = C.AreaID
		LEFT JOIN [Area].[Platform] AS E WITH (NOLOCK) ON C.PlatformID = E.PlatformID
	WHERE
		(@PlatformID IS NULL OR C.PlatformID = @PlatformID)
		AND (@AreaID IS NULL OR C.AreaID = @AreaID)
		AND (@StatTime IS NULL OR A.CreateTime >= @StatTime)
		AND (@EndTime IS NULL OR A.CreateTime < @EndTime)
		AND A.GWID is NOT NULL
		AND B.AreaID in (select AreaID from @Temp_AreaID)
	------------------------------------------------------------------------------------------



	/*  昨日數字  */
	------------------------------------------------------------------------------------------
	--計算所有的總付費與成功率
	SELECT	@yesTotalCharge = SUM(CASE WHEN A.Status=2 Then A.Amount ELSE 0 END),
			@yesTotalPointAmount = SUM(CASE WHEN A.Status=2 Then A.PointAmount ELSE 0 END),
			@yesTotalCount = Count(ID),
			@yesSuccessCount = SUM(CASE WHEN A.Status = 2 THEN 1 ELSE 0 END),
			@yesFailCount = SUM(CASE WHEN A.Status in (1,3) THEN 1 ELSE 0 END),
			@yesSuccessRate =  CAST(  @yesSuccessCount*1.0 / (@yesFailCount + @yesSuccessCount) * 100 AS Decimal(18,2) ),
			@yesChargeusers = IsNull(count(distinct (CASE WHEN A.Status=2 Then A.UserID ELSE NULL END)),0)

	FROM [CenterDB].[Pay].[OrderList] AS A WITH (NOLOCK)
		LEFT JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.UserID = B.UserID and UserType <> 2
		LEFT JOIN [Area].[Area] AS C WITH (NOLOCK) ON B.AreaID = C.AreaID
		LEFT JOIN [Area].[Platform] AS E WITH (NOLOCK) ON C.PlatformID = E.PlatformID
	WHERE
		(@PlatformID IS NULL OR C.PlatformID = @PlatformID)
		AND (@AreaID IS NULL OR C.AreaID = @AreaID)
		AND (@yesStatTime IS NULL OR A.CreateTime >= @yesStatTime)
		AND (@yesEndTime IS NULL OR A.CreateTime < @yesEndTime)
		AND A.GWID is NOT NULL
		AND B.AreaID in (select AreaID from @Temp_AreaID)
	------------------------------------------------------------------------------------------






	SET @HeadLineJson = '{"TotalCharge":' + CAST(CASE WHEN @TotalCharge IS NULL THEN '' ELSE @TotalCharge END AS VARCHAR) +
							',"TotalPointAmount":'+CAST(CASE WHEN @TotalPointAmount IS NULL THEN '' ELSE @TotalPointAmount END AS VARCHAR) +
							',"TotalCount":' + CAST(CASE WHEN @TotalCount IS NULL THEN '' ELSE @TotalCount END AS VARCHAR) +
							',"SuccessCount":' + CAST(CASE WHEN @SuccessCount IS NULL THEN '' ELSE @SuccessCount END AS VARCHAR) +
							',"FailCount":' + CAST(CASE WHEN @FailCount IS NULL THEN '' ELSE @FailCount END AS VARCHAR) + 
							',"SuccessRate":' + CAST(CASE WHEN @SuccessRate IS NULL THEN '' ELSE @SuccessRate END AS VARCHAR) +
							',"TotalChargeUser":' + CAST(CASE WHEN @chargeusers IS NULL THEN '' ELSE @chargeusers END AS VARCHAR) +
								
							',"yesTotalCharge":' + CAST(CASE WHEN @yesTotalCharge IS NULL THEN '' ELSE @yesTotalCharge END AS VARCHAR) +
							',"yesTotalPointAmount":'+CAST(CASE WHEN @yesTotalPointAmount IS NULL THEN '' ELSE @yesTotalPointAmount END AS VARCHAR) +
							',"yesTotalCount":' + CAST(CASE WHEN @yesTotalCount IS NULL THEN '' ELSE @yesTotalCount END AS VARCHAR) +
							',"yesSuccessCount":' + CAST(CASE WHEN @yesSuccessCount IS NULL THEN '' ELSE @yesSuccessCount END AS VARCHAR) +
							',"yesFailCount":' + CAST(CASE WHEN @yesFailCount IS NULL THEN '' ELSE @yesFailCount END AS VARCHAR) + 
							',"yesSuccessRate":' + CAST(CASE WHEN @yesSuccessRate IS NULL THEN '' ELSE @yesSuccessRate END AS VARCHAR) +
							',"yesTotalChargeUser":' + CAST(CASE WHEN @yesChargeusers IS NULL THEN '' ELSE @yesChargeusers END AS VARCHAR) +
							'}'							

	--取得所有資料
	;WITH CTE AS
	(
		SELECT  ROW_NUMBER() OVER (ORDER BY SuccessRate desc) AS rowNum,
		TypeName,GatewayName,TotalAmount,TotalPointAmount,SuccessCount,TotalCount,SuccessRate,TransData='' from 
		@Temp_STAT	
	)
	SELECT rowNum, TypeName,GatewayName,TotalAmount,TotalPointAmount,SuccessCount,TotalCount,SuccessRate,TransData FROM 
	CTE 
	WHERE
	rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex
	UNION ALL
	SELECT 0,'','',0,0,0,0,0,@HeadLineJson

	--增加最後一筆保存HeadLineJson
	SET @intPageCount = @intPageCount+1
END