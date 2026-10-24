USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Game_GetSuperToolServerList')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Game_GetSuperToolServerList] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  rory
-- Create date: 20190815
-- Description:	超端服務器列表
--	2020/02/11	Mars			增加status=1的判斷
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Game_GetSuperToolServerList]
(
	@intAdminID int,
	@intPlatformID int = null
)
AS
BEGIN

	SET NOCOUNT ON

	SET @intPlatformID = ISNULL(@intPlatformID, 0)

	select * into #TempAccessRights from [dbo].[Fn_GetAdminAccessRights](@intAdminID)

	SELECT a.ServerID as Id, a.*, b.*, c.GameName as [Game.GameName], d.PlatformID, d.[Name] as PlatformName
	FROM [CenterDB].[ServerInfo].[GameServerList] as a 
	join [CenterDB].[ServerInfo].[ServerPlatformRelations] as b on a.ServerID = b.ServerID
	join [CenterDB].[ServerInfo].[GameList] as c on a.GameID = c.GameID
	left join [CenterDB].[Area].[Platform] as d on b.PlatformID = d.PlatformID
	where (@intPlatformID = 0 OR b.PlatformID = @intPlatformID )
	and b.PlatformID in (select platformID from #TempAccessRights)
	and b.Status = 1 
	and a.GameID in (11, 13, 18, 19, 20, 21)
	order by b.PlatformID, b.GameID ASC

	RETURN 1
END
