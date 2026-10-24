
-- =============================================
-- Author:  Eddie
-- Create date: 2019/07/16
-- Description:	回傳不可使用的serverid
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_GetServerRelations]
 
AS
SET NOCOUNT ON

/*  回傳不可使用的serverid  */
select AreaID,GameID,ServerID,FlagID,Status
from [ServerInfo].[ServerRelations] with (nolock)
where status = 0

Return 1