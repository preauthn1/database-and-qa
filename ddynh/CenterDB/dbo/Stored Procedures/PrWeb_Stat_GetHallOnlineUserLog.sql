-- =============================================
-- Author:  alan
-- Create date: 2019/03/27
-- Description:	大廳在線人數
-- 2019-08-15 amy 調整平台權限設定
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetHallOnlineUserLog]
(
@intAdminID		int,
@intPlatformID  int,
@dtStartTime	datetime=null,
@dtEndTime		datetime=null
)
AS
BEGIN


	----平台篩選
	--DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	--DECLARE @intOPUserType int

	--select @intOPUserType=UserType from AdminSys.Admin.Users with (nolock) where UserId=@intAdminID

	----撈出該用戶可讀取的全部平台
	--IF @intPlatformID=0
	--	INSERT INTO @Temp_PlatformID Select PlatformId From CenterDB.Area.PlatformAdminUser where AdminID=@intAdminID
	--else
	--	--針對某渠道篩選
	--	INSERT INTO @Temp_PlatformID Select PlatformId From CenterDB.Area.PlatformAdminUser where AdminID=@intAdminID and PlatformID=@intPlatformID

	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	

	--加總
	if @intPlatformID=0
		SELECT
		SUM(L.TotalCount) as TotalCount,
		SUM(L.IOSCount) as IOSCount,
		SUM(L.AndroidCount) as AndroidCount,
		L.StatTime, 
		0 as PlatformId,
		'全部' as  PlatformName
		from  [Stat].HallOnLineUserLog L with (nolock) 
		left join CenterDB.Area.Platform P with (nolock) on L.PlatformID=P.PlatformID
		where 
		L.PlatformID in (select PlatformId from #Temp_AccessRights)
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		GROUP BY Stattime
		ORDER BY Stattime DESC
	--個別
	else
		SELECT
		L.TotalCount  as TotalCount,
		L.IOSCount  as IOSCount,
		L.AndroidCount as AndroidCount,
		L.StatTime,
		L.PlatformID,
		P.Name as PlatformName
		from  [Stat].HallOnLineUserLog L with (nolock) 
		left join CenterDB.Area.Platform P  with (nolock) on L.PlatformID=P.PlatformID
		where 
		--L.PlatformID in (select PlatformId from #Temp_AccessRights)
		(L.PlatformID = @intPlatformID AND L.PlatformID in (select PlatformId from #Temp_AccessRights))
		AND (@dtStartTime IS NULL OR StatTime >= @dtStartTime)
		AND (@dtEndTime IS NULL OR StatTime <= @dtEndTime)
		ORDER BY Stattime DESC

		DROP TABLE #Temp_AccessRights
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_Stat_GetHallOnlineUserLog] TO [GameUser]
    AS [dbo];
GO
