


-- =============================================
-- Author:  <xxxx>
-- Create date: <xxxx>
-- Description:	<取得游戏别名清单>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Area_GetGameAliasName]
@intGameID INT = NULL,
@intIconID INT = NULL
AS
BEGIN

	SELECT * From Area.GameAliasName
	Where
	ISNULL(@intGameID, GameID) = GameID
	AND
	ISNULL(@intIconID, IconID) = IconID
	ORDER BY GameID 
END


