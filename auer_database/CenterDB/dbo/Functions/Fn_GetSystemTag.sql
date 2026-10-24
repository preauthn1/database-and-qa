
-- =============================================
-- Author:  Eddie
-- Create date: 2019/07/24
-- Description:	取得系統標示(eg. 方舟、986、藍鑽)
-- =============================================
CREATE FUNCTION [dbo].[Fn_GetSystemTag]
()
RETURNS varchar(20)
AS
BEGIN
	
	declare @chvSystemTag varchar(20)
	select  @chvSystemTag = SystemTag
	from [CenterDB].[ServerInfo].[SystemConfig]
	return ISNULL(@chvSystemTag,'--')
END

