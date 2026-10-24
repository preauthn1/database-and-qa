-- =============================================
-- Author:		<xxx>
-- Create date: <xxx>
-- Description:	<查询每局游戏记录>
--	2018/03/26	Jason		新增d.GradeID as 'GradeID',
--	2018/04/13	Jason		取消輸入參數@chvLogId VARCHAR(256)   一律使用@longDealNo
--	2018/04/16	Jason		調整語法及結構 取消@chvDeskCode
--	2019/09/27	Marshall	新增參數 AdminID
--	2019/11/06	Marshall	排序欄位改成GameTime、因為Id欄位根本沒建索引、超級慢、處理奇怪的問題
--  2019/12/09	Louis		捨棄使用[Days]篩選，直接使用傳入的@dtBeginTime、@dtEndTime
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_PerLog_SearchPerGameDetail]
	@intUserID		INT = NULL,			--用户ID
	@intGameID		INT = NULL,			--游戏ID
	@intServerID	INT = NULL,			--服务器ID
	@longDealNo     BIGINT = NULL,		--牌局号 --牌局标识
	@chvDeskCode	VARCHAR(15) = NULL,	--房间口令
	@dtBeginTime	DATETIME = NULL,	--开始时间范围
	@dtEndTime		DATETIME = NULL,	--结束时间范围
	@intAdminID		INT = NULL,			--後台帳號ID
	@intPageIndex	int = 1,
	@intPageSize    int = 20,
	@intPageCount   int			OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	--如果沒有帶任何值, 預設查詢1小時範圍
	IF @dtBeginTime IS NULL AND  @dtEndTime IS NULL
	BEGIN
		SET @dtEndTime = GETDATE()
		SET @dtBeginTime = DATEADD(HOUR,-1,@dtEndTime)
	END
	ELSE
	--如果開始時間沒有帶任何值,結束時間有帶值,預設查詢1小時範圍
	IF @dtBeginTime IS NULL AND @dtEndTime IS NOT NULL
	BEGIN
		SET @dtBeginTime = dateadd(HOUR,-1,@dtEndTime)
	END
	--如果結束時間沒有帶值,預設查詢1小時範圍
	ELSE IF @dtEndTime IS NULL
	BEGIN
		SET @dtEndTime = dateadd(HOUR,1,@dtBeginTime)
	END

	/*  暫時使用  */
	-----------------------------------------------------------------------------------------------------
	DECLARE @isFindServerID BIT 
	SET @isFindServerID = 1
	
	CREATE TABLE #TempUserIDs (UserID INT NOT NULL)		

	IF @intAdminID is not NULL
		BEGIN

			--姑且篩選最後登入時間有大於指定日期的，可以濾掉一部份資料
			--如果有輸入指定的UserID 直接過濾
			INSERT INTO #TempUserIDs
			SELECT UserID FROM CENTERDBLINKEDSERVER.[Centerdb].[Users].[UserInfo] WITH (NOLOCK)
			WHERE LastLogonTime >= @dtBeginTime  AND UserID =(ISNULL(@intUserID, UserID)) AND AreaID in
			(
				SELECT AreaID FROM CENTERDBLINKEDSERVER.[Centerdb].[Area].[AreaAdminUser] WITH (NOLOCK)
				WHERE AdminID = @intAdminID
			)

		END
	
	
	CREATE TABLE #TempServerID(ServerID INT NOT NULL)		
	IF @intServerID IS NULL AND @intGameID IS NOT NULL
	BEGIN
		INSERT INTO #TempServerID	
		SELECT ServerID 	
		FROM CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameServerList WHERE GameID = @intGameID	
	END
	ELSE IF @intServerID IS NOT NULL
	BEGIN
		INSERT INTO #TempServerID 
		SELECT @intServerID
		FROM CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameServerList WHERE ServerID = @intServerID	
	END
	
	SET @isFindServerID = CASE WHEN EXISTS(SELECT 1 FROM #TempServerID) THEN 1 ELSE 0 END
	-----------------------------------------------------------------------------------------------------
	---總筆數的部分
	SELECT  @intPageCount = COUNT(*) 
	FROM PerLog.DetailLog as a with(NOLOCK)		 
	WHERE
		a.GameTime >= @dtBeginTime AND a.GameTime <= @dtEndTime
		AND (@isFindServerID = 0 OR a.ServerID IN(SELECT ServerID FROM #TempServerID))
		AND (ISNULL(@intUserID,a.UserID) = a.UserID)
		AND (ISNULL(@longDealNo,a.LogID) = a.LogID)
		AND (a.UserID in (SELECT UserID FROM #TempUserIDs))
		AND (@intAdminID is NULL OR a.UserID in (SELECT UserID FROM #TempUserIDs))
	---原本的寫法是 AND (@intAdminID is NULL OR a.UserID in (SELECT UserID FROM #TempUserIDs)) 但是速度超級慢
	---只要多了 @intAdminID is NULL OR ....速度就會差40秒以上。不曉得為何。只好這樣寫

	--IF @intAdminID is NULL
	--BEGIN
	--	SELECT  @intPageCount = COUNT(*) 
	--	FROM PerLog.DetailLog as a with(NOLOCK)		 
	--	WHERE
	--		a.GameTime >= @dtBeginTime AND a.GameTime <= @dtEndTime
	--		AND (@isFindServerID = 0 OR a.ServerID IN(SELECT ServerID FROM #TempServerID))
	--		AND (ISNULL(@intUserID,a.UserID) = a.UserID)
	--		AND (ISNULL(@longDealNo,a.LogID) = a.LogID)
	--END
	--ELSE
	--BEGIN
	--	SELECT  @intPageCount = COUNT(*) 
	--	FROM PerLog.DetailLog as a with(NOLOCK)		 
	--	WHERE
	--		a.GameTime >= @dtBeginTime AND a.GameTime <= @dtEndTime
	--		AND (@isFindServerID = 0 OR a.ServerID IN(SELECT ServerID FROM #TempServerID))
	--		AND (ISNULL(@intUserID,a.UserID) = a.UserID)
	--		AND (ISNULL(@longDealNo,a.LogID) = a.LogID)
	--		AND (a.UserID in (SELECT UserID FROM #TempUserIDs))
	--END

	---分頁的部分
	;with tb AS 
	(		
		SELECT a.[Id],a.[LogID],a.[ServerID],a.[UserID],a.[CurrentAmount],a.[UpdateAmount],a.[GameTime],
				ROW_NUMBER() over(order by a.GameTime desc) as rowid
		FROM PerLog.DetailLog as  a with(NOLOCK) 
		WHERE
			a.GameTime >= @dtBeginTime AND a.GameTime <= @dtEndTime
			AND (@isFindServerID = 0 OR a.ServerID IN(SELECT ServerID FROM #TempServerID))
			AND (ISNULL(@intUserID,a.UserID) = a.UserID)
			AND (ISNULL(@longDealNo,a.LogID) = a.LogID)
			AND (@intAdminID is NULL OR a.UserID in (SELECT UserID FROM #TempUserIDs))
	), 
	result AS 
	(
		SELECT * 
		FROM tb 
		WHERE rowid between @intPageSize * (@intPageIndex-1) + 1  and @intPageSize * @intPageIndex
	)


	SELECT	result.*,
			b.ServerName as 'ServerName',
			c.GameName as 'GameName',
			d.LoginName as 'LoginName',
			d.NickName as 'NickName',
			d.GradeID as 'GradeID',
			f.Name as 'PlatformName'
	FROM result		
		INNER JOIN CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameServerList as b on result.ServerID = b.ServerID
		INNER JOIN CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameList as c on b.GameID = c.GameID
		INNER JOIN CENTERDBLINKEDSERVER.[Centerdb].Users.UserInfo as d on result.UserID = d.UserID
		INNER JOIN CENTERDBLINKEDSERVER.[Centerdb].Area.Area as e on d.AreaID=e.AreaID
		INNER JOIN CENTERDBLINKEDSERVER.[Centerdb].Area.Platform as f on e.PlatformID=f.PlatformID
	order by result.rowid asc
		
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_PerLog_SearchPerGameDetail] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_PerLog_SearchPerGameDetail] TO [xbuser]
    AS [dbo];

