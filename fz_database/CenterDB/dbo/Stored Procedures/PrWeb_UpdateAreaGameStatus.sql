

-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<更新AreaGameStatus>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UpdateAreaGameStatus]
@intID INT,			   --AreaGame
@tnyStatus	int		   --状态						   

AS
BEGIN
	--更新[GameList]
	UPDATE [CenterDB].[Area].[GameList]
	SET Status = @tnyStatus
	WHERE [ID] = @intID

	RETURN 1
END


