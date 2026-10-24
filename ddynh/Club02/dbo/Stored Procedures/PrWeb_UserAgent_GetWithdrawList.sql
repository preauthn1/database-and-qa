-- =============================================
-- Author:  jason
-- Create date: 2019/04/13
-- Description: USER 查询领取收益提现页面
-- 2019-09-17 amy	修改可使用USERID查詢(@intUserID = 登入者ID，@intSubUserID = 查詢玩家ID)
-- 2019-09-18 amy	加上權限的搜尋條件與刪除 总收益/今日可提现 計算，調整 已提现收益 計算
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UserAgent_GetWithdrawList]
(
	@intAdminID	int = null,
	@intUserID	int = null,
	@intSubUserID	int = null,
	@dtStartTime	datetime = null,
	@dtEndTime		datetime = null
)
AS
BEGIN

	set nocount on

	declare @logdate	datetime = dateadd(day,0,datediff(day,0,getdate()))

	set @dtStartTime = isnull(@dtStartTime,'1970-01-01')
	set @dtEndTime = isnull(@dtEndTime,'2100-01-01')
	set @dtStartTime = dateadd(day,0,datediff(day,0,@dtStartTime))
	set @dtEndTime = dateadd(day,0,datediff(day,0,@dtEndTime))


	--平台暂存
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT,PlatformName varchar(50),AreaID int,AreaName varchar(50))

	if(@intAdminID is not null)
	begin
		--捞出该用户可读取的全部平台
		INSERT INTO @Temp_PlatformID
		Select	B.PlatformID,
				C.Name,
				B.AreaID,
				B.AreaName
		From [dbo].[AgentPlatformRelations] as a
			inner join CenterDB.area.area as b with (nolock) on a.PlatformID = B.PlatformID
			inner join CenterDB.area.[platform] as c with (nolock) on b.PlatformID = c.PlatformID
		where
			a.AdminID = @intAdminID
	end

	if(@intUserID is not null)
	begin
		insert into @Temp_PlatformID
		Select	B.PlatformID,
				C.Name,
				B.AreaID,
				B.AreaName
		From [dbo].[UserAgentInfo] as a
			inner join CenterDB.area.area as b with (nolock) on a.PlatformID = B.PlatformID
			inner join CenterDB.area.[platform] as c with (nolock) on b.PlatformID = c.PlatformID
		where
			a.userid = @intUserID
	end

	/*  计算总收益/已提现收益/今日可提现  */
	declare @temp_totalTaxAmount bigint
	declare @temp_convertAmount	bigint
	declare @temp_performedAmount bigint

	select	@temp_totalTaxAmount = sum([SumTaxBonus]),
			--@temp_convertAmount = sum([SumTaxConvert]),
			@temp_performedAmount = sum([UnWithDrawTotal])
	from [dbo].[UserAgentInfo] with (nolock)
	where
	[UserID] = ISNULL(@intSubUserID,[UserID])

	set @temp_totalTaxAmount	= isnull(@temp_totalTaxAmount,0)
	--set @temp_convertAmount	= isnull(@temp_convertAmount,0)
	set @temp_performedAmount	= isnull(@temp_performedAmount,0)

	/*  提现纪录  */
	SELECT	[LogDate] = a.[LogDate],
			[WithdrawAmount] = a.[WithdrawAmount],
			[Status] = case	when a.[Status] = 0 then '审核中'
							when a.[Status] = 1 then '已退还'
							when a.[Status] = 2 then '已提取'
						else '未处理' end
	INTO #TempTable
	FROM [dbo].[UserAgentWithDraw] AS a WITH (NOLOCK)
	INNER JOIN [dbo].[UserAgentInfo] AS b WITH (NOLOCK) ON a.UserID = b.UserID
	WHERE
		a.[UserID] = ISNULL(@intSubUserID,a.[UserID])
		AND a.[LogDate] >= @dtStartTime
		AND a.[LogDate] < @dtEndTime
		AND b.PlatformID IN (SELECT PlatformID FROM @Temp_PlatformID)
		AND b.AreaID IN (SELECT AreaID FROM @Temp_PlatformID)
	order by convert(varchar(10),[LogDate],23),[Status]

	/*  计算 回传 已提现收益  */
	SELECT @temp_convertAmount = SUM(CAST(WithdrawAmount AS BIGINT))
	FROM #TempTable

	set @temp_convertAmount	= isnull(@temp_convertAmount,0)

	/*  回传总收益/以提现收益/今日可提现  */
	select	TotalTaxAmount = @temp_totalTaxAmount, --总收益
			ConvertAmount = @temp_convertAmount,	--以提现收益
			PerformedAmount = @temp_performedAmount	--今日可提现

	/* 回传  提现纪录  */
	SELECT * FROM #TempTable

	
	DROP TABLE #TempTable
	return 1
END






