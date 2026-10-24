-- =============================================
-- Author:		<xxx>
-- Create date: <xxx>
-- Description:	<查询每局游戏记录详细>
--	2018/03/26	Jason	新增d.GradeID as 'GradeID'
--  2018/06/26  Harry   新增d.RealName,d.UnionpayRealName
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_PerLog_GetDetailLogByLogID]
	@intAdminID		INT = NULL,
	@chvLogID		varchar(32),			--牌局标识
	@dtGameTime     DATETIME				--游戏时间
AS
BEGIN

	select a.*,b.ServerName as 'ServerName',c.GameName as 'GameName',
		   d.LoginName as 'LoginName',d.NickName as 'NickName',d.GradeID as 'GradeID',
		   d.RealName,d.UnionpayRealName,
		   d.LastLogonIPAddress,
		   d.UserType,
		   e.areaID
		   ,f.PlatformID, f.Name as PlatformName 
	from PerLog.DetailLog as a 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameServerList as b on a.ServerID = b.ServerID 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameList as c on b.GameID = c.GameID 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].Users.UserInfo as d on a.UserID = d.UserID 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].Area.Area as e on e.AreaID = d.AreaID 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].Area.Platform as f on f.PlatformID = e.PlatformID 
	where a.LogID = @chvLogID
		 AND a.GameTime BETWEEN DATEADD(HOUR,-1,@dtGameTime) AND DATEADD(HOUR,1,@dtGameTime)
	
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_PerLog_GetDetailLogByLogID] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_PerLog_GetDetailLogByLogID] TO [xbuser]
    AS [dbo];

