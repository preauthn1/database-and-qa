-- =============================================
-- Author:		<xxx>
-- Create date: <xxx>
-- Description:	<查询每局游戏记录>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_PerLog_GetPerGameLogByLogID]
	@chvLogID		varchar(32),			--牌局标识
	@dtGameTime     DATETIME				--游戏时间
AS
BEGIN

	select a.*,b.ServerName as 'ServerName',c.GameName as 'GameName'	   
	from PerLog.PerGameLog as a 
		 inner join CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameServerList as b on a.ServerID = b.ServerID
		 inner join CENTERDBLINKEDSERVER.[Centerdb].ServerInfo.GameList as c on b.GameID = c.GameID
		 
	where a.Id = @chvLogID
	     AND a.EndTime = @dtGameTime
	
END
