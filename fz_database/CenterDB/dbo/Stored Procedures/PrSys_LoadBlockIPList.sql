-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<加载封锁IP列表>
-- =============================================
CREATE PROCEDURE [dbo].[PrSys_LoadBlockIPList]
AS
SET NOCOUNT ON

SELECT IPAddress FROM Game.ForbidIPAddress

RETURN 1
