


-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<删除GameList>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_DeleteAreaGame]			
@intID INT,	
@chvErrMsg	VARCHAR(256) OUTPUT		--返回消息
AS
BEGIN

	--删除GameList
	Delete from [CenterDB].[Area].[GameList] where Id = @intID
	SET @chvErrMsg = '删除成功'
	RETURN 1
END


