USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_GetOnlineSummary_EachGame')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_GetOnlineSummary_EachGame] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO


/****** Object:  StoredProcedure [dbo].[PrWeb_GetOnlineSummary_EachGame]    Script Date: 2020/2/18 上午 11:22:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  各遊戲在線用戶
-- Create date: 2020-02-18
-- Description:	在線玩家總匯
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_GetOnlineSummary_EachGame]
(
	@intAdminID					INT
)
AS
BEGIN
	
	SET NOCOUNT ON

	--渠道篩選(根據登入
	DECLARE @Temp_AreaID TABLE (AreaID	INT)
	INSERT INTO @Temp_AreaID Select AreaID From Area.AreaAdminUser where AdminID=@intAdminID









	--各個遊戲在線玩家統計
	SELECT	Z.GameID,
			Z.GameName,
					TotalCount = ISNULL(TotalCount,0)
			FROM [ServerInfo].[GameList] AS Z WITH (NOLOCK)
			LEFT JOIN (
				SELECT	C.GameID,TotalCount = COUNT(A.UserID)
				FROM [Game].[GameUserList] AS A WITH (NOLOCK)
					INNER JOIN [Users].[UserInfo] AS B WITH (NOLOCK) ON A.UserID = B.UserID AND B.UserType <> 2
					INNER JOIN [ServerInfo].[GameServerList] AS C WITH (NOLOCK) ON A.ServerID = C.ServerID
				WHERE B.AreaID in (select AreaID from @Temp_AreaID)
				GROUP BY C.GameID
			) AS B ON Z.GameID = B.GameID
	WHERE Z.GameID in
	(
		--有分配伺服器的遊戲才顯示
		select GameID from [ServerInfo].[ServerPlatformRelations] WHERE Status = 1
	)
	ORDER BY Z.GameID


END




