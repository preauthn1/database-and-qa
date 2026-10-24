-- =============================================
-- Author:  alan
-- Create date: 20180929
-- Description:	有效用户留存率
-- 2019/12/16	Louis	修正部分段落錯誤，缺少Group By PlatformID
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_StatActiveUserKeepLog]
AS
BEGIN
	SET NOCOUNT ON

	declare @dtNow datetime=getdate()
	declare @dtCreateTime datetime
	declare @intYYYYMMDD int
	declare @intNowYYYYMMDD int= CAST ( CONVERT(varchar,@dtNow,112) AS INT)
	declare @intChargeUser int
	declare @intTodayActiveCount int
	declare @intActiveCount int


	--初始資料
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intNowYYYYMMDD as YYYYMMDD, PlatformID from area.Platform
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN NOT MATCHED THEN
		insert 
		(YYYYMMDD,PlatformID,ActiveUsers,[Day1Keep],[Day3Keep],[Day5Keep],[Day7Keep],[Day14Keep],[Day30Keep],[Day3PayRate],[Day5PayRate],[Day7PayRate])
		values 
		(B.YYYYMMDD,B.PlatformID,0,0,0,0,0,0,0,0,0,0);



	--更新今日有效新增用户数 (当天新增的用户中，任意进入游戏中体验游戏时长>=30秒以上的新用户数量)
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		Select @intNowYYYYMMDD as YYYYMMDD, A.PlatformID,Count(G.UserID) as Amount
		from CenterDB.Game.UserGameInfo G with (nolock) 
		left join users.UserInfo U with (nolock) on G.userid=U.UserID
		left join Area.Area A with (nolock) on A.AreaID=U.AreaID
		Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intNowYYYYMMDD AND G.GameTime >= 30 --sec
		Group by A.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.ActiveUsers=ISNULL(B.Amount,0);


	--取得今日登入遊戲用戶清單
	select G.PlatformID, G.userid into #TodayLoginUser
	from logdb.game.GameLog G with (nolock) 
	left join CenterDB.Users.UserInfo U with (nolock) on G.UserID=U.UserID
	where U.UserType <> 2 AND G.LoginTime >= CAST(CONVERT(varchar,@dtNow,110) as datetime) 
	-------------------------------------------------------------



	SET @dtCreateTime = DateAdd(day,-1,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)

	--1日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser1
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--1日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount1
	from #ActiveUser1
	group by PlatformID

	--1日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount1
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser1 )
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount1 A
		left join #TodayActiveUserCount1 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day1Keep=ISNULL(B.Amount,0);

	-------------------------------------------------------------

	  
	--有效用户的3日留存
	SET @dtCreateTime = DateAdd(day,-3,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)



	--3日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser3
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--3日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount3
	from #ActiveUser3
	group by PlatformID

	--3日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount3
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser3)
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount3 A
		left join #TodayActiveUserCount3 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day3Keep=ISNULL(B.Amount,0);





	--有效用户至今的付费人數 
	select 
	A.PlatformID, COUNT(U.UserID) as Amount 
	into #ActivePayUseCount3
	from users.UserInfo U with(nolock)
	left join Area.Area A with(nolock) on U.AreaID=A.AreaID 
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD and (SumCharge+SumAgentCharge)>0
	and U.UserId in (select UserId from #ActiveUser3)
	GROUP BY A.PlatformID

	--有效用户至今的付费人數/有效用户的人数
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.Amount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount3 A
		left join #ActivePayUseCount3 B on A.PlatformID=B.PlatformID

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day3Payrate=ISNULL(B.Amount,0);




	-------------------------------------------------------------  
	--有效用户的5日留存
	SET @dtCreateTime = DateAdd(day,-5,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)



	--5日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser5
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--5日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount5
	from #ActiveUser5
	group by PlatformID

	--5日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount5
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser5)
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount5 A
		left join #TodayActiveUserCount5 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day5Keep=ISNULL(B.Amount,0);




	--有效用户至今的付费人數 
	select 
	A.PlatformID, COUNT(U.UserID) as Amount
	into #ActivePayUseCount5
	from users.UserInfo U with(nolock)
	left join Area.Area A with(nolock) on U.AreaID=A.AreaID 
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD and (SumCharge+SumAgentCharge)>0
	and U.UserId in (select UserId from #ActiveUser5)
	GROUP BY A.PlatformID


	--有效用户至今的付费人數/有效用户的人数
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.Amount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount5 A
		left join #ActivePayUseCount5 B on A.PlatformID=B.PlatformID

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day5Payrate=ISNULL(B.Amount,0);



	-------------------------------------------------------------  
	--有效用户的7日留存
	SET @dtCreateTime = DateAdd(day,-7,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)
	

	--7日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser7
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--7日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount7
	from #ActiveUser7
	group by PlatformID

	--7日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount7
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser7)
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount7 A
		left join #TodayActiveUserCount7 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day7Keep=ISNULL(B.Amount,0);




	--有效用户至今的付费人數 
	select 
	A.PlatformID, COUNT(U.UserID) as Amount
	into #ActivePayUseCount7
	from users.UserInfo U with(nolock)
	left join Area.Area A with(nolock) on U.AreaID=A.AreaID 
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD and (SumCharge+SumAgentCharge)>0
	and U.UserId in (select UserId from #ActiveUser7)
	GROUP BY A.PlatformID

	--有效用户至今的付费人數/有效用户的人数
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.Amount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount7 A
		left join #ActivePayUseCount7 B on A.PlatformID=B.PlatformID

	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day7Payrate=ISNULL(B.Amount,0);



	-------------------------------------------------------------  
	--有效用户的14日留存
	SET @dtCreateTime = DateAdd(day,-14,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)




	--14日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser14
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--14日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount14
	from #ActiveUser14
	group by PlatformID

	--14日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount14
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser14)
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount14 A
		left join #TodayActiveUserCount14 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day14Keep=ISNULL(B.Amount,0);


	-------------------------------------------------------------  

	--有效用户的30日留存
	SET @dtCreateTime = DateAdd(day,-30,GETDATE())
	SET @intYYYYMMDD = CAST (CONVERT(varchar,@dtCreateTime,112) AS INT)




	--30日前建立的有效用户清單 (登入遊戲超過30秒)
	select A.PlatformID, G.UserID 
	into #ActiveUser30
	from CenterDB.Game.UserGameInfo G with (nolock) 
	left join users.UserInfo U with (nolock)  on G.userid=U.UserID
	left join area.Area A  with (nolock) on A.AreaID=U.AreaID
	Where CAST ( CONVERT(varchar,U.CreateTime,112) AS INT) = @intYYYYMMDD AND G.GameTime >= 30 --sec

	--30日前建立的有效用户數量
	select PlatformID,COUNT(UserID) as ActiveUserCount 
	into #ActiveUserCount30
	from #ActiveUser30
	group by PlatformID

	--30日前建立且今日有登入的使用者數量
	select PlatformID,Count(UserID) as TodayActiveUserCount
	into #TodayActiveUserCount30
	from #TodayLoginUser
	where userid in (select userid from #ActiveUser30)
	group by PlatformID


	--更新留存率
	MERGE Stat.ActiveUserKeepLog as A
	USING 
	(
		select @intYYYYMMDD as YYYYMMDD,A.PlatformID ,B.TodayActiveUserCount*1.0/A.ActiveUserCount * 100 as Amount
		from #ActiveUserCount30 A
		left join #TodayActiveUserCount30 B on A.PlatformID=B.PlatformID
	) as B
	ON (A.YYYYMMDD=B.YYYYMMDD AND A.PlatformID=B.PlatformID)
	WHEN MATCHED THEN
		update set
		A.Day30Keep=ISNULL(B.Amount,0);



	-------------------------------------------------------------  

END
GO


