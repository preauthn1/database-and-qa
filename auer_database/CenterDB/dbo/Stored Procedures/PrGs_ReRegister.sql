-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<GameServer注册>
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_ReRegister]
@intServerID INT,
@intServerType INT 
AS
SET NOCOUNT ON
IF @intServerType = 0
UPDATE ServerInfo.GameServerList
SET LastUpdateTime = GETDATE()
WHERE ServerID = @intServerID
ELSE
UPDATE ServerInfo.PlazaServerList
SET LastUpdateTime = GETDATE()
WHERE ServerID = @intServerID

RETURN 1
