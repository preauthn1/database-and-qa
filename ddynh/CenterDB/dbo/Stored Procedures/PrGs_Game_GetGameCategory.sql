-- =============================================
-- Author:		Marshall
-- Create date: 2019-12-13
-- Description:	取得遊戲分類
-- =============================================

CREATE PROCEDURE [dbo].[PrGs_Game_GetGameCategory]
AS
BEGIN
	
	--Result 1. 取得遊戲分類
	SELECT Id AS CategoryID , [Name] 
	FROM  [ServerInfo].[GameCategory] WITH (NOLOCK)
	WHERE Status = 1

	
	--Result 2. 取得遊戲分類mapping (逗號隔開)
	SELECT t1.GameID , 
	(
		SELECT ISNULL(Stuff((SELECT ', ' + cast(t2.GameCategoryID AS nvarchar(50)) , ''
		FROM [ServerInfo].[GameCategorySetting] AS t2 WITH (NOLOCK)
		WHERE t1.GameID = t2.GameID AND t2.GameCategoryID in 
		(		
			SELECT Id FROM [ServerInfo].[GameCategory] WHERE Status = 1
		)
		FOR XML PATH('')), 1, 1, '') , '') 
	) AS CategoryIDs
	FROM [ServerInfo].[GameCategorySetting] AS t1 WITH (NOLOCK)
	GROUP BY GameID

END