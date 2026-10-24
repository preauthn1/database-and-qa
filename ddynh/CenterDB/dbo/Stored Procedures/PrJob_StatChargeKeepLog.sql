-- =============================================
-- Author:  alan
-- Create date: 20180929
-- Description:	充直统计留存率
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_StatChargeKeepLog]
AS
BEGIN
	SET NOCOUNT ON

	declare @dtNow datetime=getdate()
	declare @dtCreateTime datetime
	declare @intNowYYYYMMDD int=CAST ( CONVERT(varchar,@dtNow,112) AS INT)
	declare @intYYYYMMDD int
	declare @intTodayRegCount int
	declare @intRegCount int


	--HD TYPE: 1 PC, 2 Android, 3 IOS
	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		select @intNowYYYYMMDD as YYYYMMDD,2 as HDType, PlatformID from area.Platform
		union
		select @intNowYYYYMMDD as YYYYMMDD,3 as HDType, PlatformID from area.Platform
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN NOT MATCHED THEN
		insert 
		(YYYYMMDD,PlatformID,HDType,[Day1Keep],[Day2Keep],[Day7Keep],[Day30Keep])
		values 
		(B.YYYYMMDD,B.PlatformID,B.HDType,0,0,0,0);
	


	--更新今日註冊且付費人數
  	SET @intYYYYMMDD = CAST ( CONVERT(varchar,@dtNow,112) AS INT)

	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		select @intNowYYYYMMDD as YYYYMMDD,count(U.userid) as Amount, U.HDType ,A.PlatformID 
		from CenterDB.users.UserInfo U with (nolock) 
		left join Area.Area A with (nolock) on U.AreaID=A.AreaID
		where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD and (U.SumCharge+U.SumAgentCharge) > 0
		group by PlatformID,HDType

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN MATCHED THEN
		update set
		A.RegChargeUsers=ISNULL(B.Amount,0);

	-----------------------------------------------------------


	--今日登入清單
    select userid,hdtype,logintime, A.PlatformID into #TodayLoginUser
	from logdb.game.GameLog G with (nolock) 
	
	left join area.Area A with (nolock) on G.AreaID=A.AreaID
	where LoginTime >= CAST(Convert(varchar,@dtNow,110) as datetime)
	and hdtype <> 1
	-------------------------------------------------------------



	SET @dtCreateTime = DateAdd(day,-1,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)

	--1day前註冊且有充值
	select U.HDType,U.UserID,A.PlatformID into #RegChargeUser1
	from CenterDB.users.UserInfo U with (nolock)
	left join Area.Area A with (nolock) on U.AreaID=A.AreaID
	where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD
	and (U.SumCharge+U.SumAgentCharge) > 0
	  
	select HDType,PlatformID,Count(UserID) as RegChargeUserCount
	into #RegChargeUserCount1
	from #RegChargeUser1
	group by HDType,PlatformID

	--1day前註冊且有充值且今日有登入的次數
	select HDType,PlatformID,Count(UserID) as LoginUserCount
	into #LoginUserCount1
	from #TodayLoginUser with (nolock) 
	where userid in (
	select userid from #RegChargeUser1
	)
	group by HDType,PlatformID

	--更新數據
	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		--計算留存率 (登入人數/註冊且充值人數)
		select @intYYYYMMDD as YYYYMMDD, R.PlatformID, R.HDType, LoginUserCount*1.0/RegChargeUserCount * 100 as Amount 
		from #RegChargeUserCount1 R with (nolock)
		left join #LoginUserCount1 L with (nolock)
		on R.PlatformID=L.PlatformID and R.HDType=L.HDType
	  

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN MATCHED THEN
		update set
		A.Day1Keep=ISNULL(B.Amount,0);
	-------------------------------------------------------------


	SET @dtCreateTime = DateAdd(day,-2,GETDATE())
	SET @intYYYYMMDD = CAST ( CONVERT(varchar,@dtCreateTime,112) AS INT)


	--2day前註冊且有充值
	select U.HDType,U.UserID,A.PlatformID into #RegChargeUser2
	from CenterDB.users.UserInfo U with (nolock)
	left join Area.Area A with (nolock) on U.AreaID=A.AreaID
	where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD
	and (U.SumCharge+U.SumAgentCharge) > 0
	  
	select HDType,PlatformID,Count(UserID) as RegChargeUserCount
	into #RegChargeUserCount2
	from #RegChargeUser2
	group by HDType,PlatformID

	--2day前註冊且有充值且今日有登入的次數
	select HDType,PlatformID,Count(UserID) as LoginUserCount
	into #LoginUserCount2
	from #TodayLoginUser with (nolock) 
	where userid in (
	select userid from #RegChargeUser2
	)
	group by HDType,PlatformID

	--更新數據
	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		--計算留存率 (登入人數/註冊且充值人數)
		select @intYYYYMMDD as YYYYMMDD, R.PlatformID, R.HDType, LoginUserCount*1.0/RegChargeUserCount * 100 as Amount 
		from #RegChargeUserCount2 R with (nolock)
		left join #LoginUserCount2 L with (nolock)
		on R.PlatformID=L.PlatformID and R.HDType=L.HDType
	  

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN MATCHED THEN
		update set
		A.Day1Keep=ISNULL(B.Amount,0);
	-------------------------------------------------------------


	SET @dtCreateTime = DateAdd(day,-7,GETDATE())
	SET @intYYYYMMDD = CAST ( CONVERT(varchar,@dtCreateTime,112) AS INT)

	--7day前註冊且有充值
	select U.HDType,U.UserID,A.PlatformID into #RegChargeUser7
	from CenterDB.users.UserInfo U with (nolock)
	left join Area.Area A with (nolock) on U.AreaID=A.AreaID
	where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD
	and (U.SumCharge+U.SumAgentCharge) > 0
	  
	select HDType,PlatformID,Count(UserID) as RegChargeUserCount
	into #RegChargeUserCount7
	from #RegChargeUser7
	group by HDType,PlatformID

	--7day前註冊且有充值且今日有登入的次數
	select HDType,PlatformID,Count(UserID) as LoginUserCount
	into #LoginUserCount7
	from #TodayLoginUser with (nolock) 
	where userid in (
	select userid from #RegChargeUser7
	)
	group by HDType,PlatformID

	--更新數據
	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		--計算留存率 (登入人數/註冊且充值人數)
		select @intYYYYMMDD as YYYYMMDD, R.PlatformID, R.HDType, LoginUserCount*1.0/RegChargeUserCount * 100 as Amount 
		from #RegChargeUserCount7 R with (nolock)
		left join #LoginUserCount7 L with (nolock)
		on R.PlatformID=L.PlatformID and R.HDType=L.HDType
	  

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN MATCHED THEN
		update set
		A.Day1Keep=ISNULL(B.Amount,0);
	-------------------------------------------------------------

	SET @dtCreateTime = DateAdd(day,-30,GETDATE())
	SET @intYYYYMMDD = CAST ( CONVERT(varchar,@dtCreateTime,112) AS INT)

	--30day前註冊且有充值
	select U.HDType,U.UserID,A.PlatformID into #RegChargeUser30
	from CenterDB.users.UserInfo U with (nolock)
	left join Area.Area A with (nolock) on U.AreaID=A.AreaID
	where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD
	and (U.SumCharge+U.SumAgentCharge) > 0
	  
	select HDType,PlatformID,Count(UserID) as RegChargeUserCount
	into #RegChargeUserCount30
	from #RegChargeUser30
	group by HDType,PlatformID

	--30day前註冊且有充值且今日有登入的次數
	select HDType,PlatformID,Count(UserID) as LoginUserCount
	into #LoginUserCount30
	from #TodayLoginUser with (nolock) 
	where userid in (
	select userid from #RegChargeUser30
	)
	group by HDType,PlatformID

	--更新數據
	MERGE Stat.ChargeKeepLog as A
	USING 
	(
		--計算留存率 (登入人數/註冊且充值人數)
		select @intYYYYMMDD as YYYYMMDD, R.PlatformID, R.HDType, LoginUserCount*1.0/RegChargeUserCount * 100 as Amount 
		from #RegChargeUserCount30 R with (nolock)
		left join #LoginUserCount30 L with (nolock)
		on R.PlatformID=L.PlatformID and R.HDType=L.HDType
	  

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID AND A.HDType=B.HDType)
	WHEN MATCHED THEN
		update set
		A.Day1Keep=ISNULL(B.Amount,0);	
	-------------------------------------------------------------
  

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrJob_StatChargeKeepLog] TO [xbuser]
    AS [dbo];

