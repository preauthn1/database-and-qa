
-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<取得代理支付总代理資料>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_AgentTotal_Get]
(
	@intAdminId			INT,
	@intAgentID			INT					--代理ID
)
AS
BEGIN

	--平台篩選
	DECLARE @Temp_PlatformID TABLE (PlatformID	INT)
	Declare @intPlatformID int	
	INSERT INTO @Temp_PlatformID Select PlatformId From CenterDB.Area.PlatformAdminUser where AdminID=@intAdminId

	

		SELECT	*,'AE' as name
		FROM AdminSys.dbo.agent_total AS A WITH (NOLOCK)
		WHERE id = @intAgentID

END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_AgentTotal_Get] TO [GameUser]
    AS [dbo];

