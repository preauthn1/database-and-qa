-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<获取查询邮件的时间范围>
-- =============================================
CREATE FUNCTION [dbo].[Fn_EmailStartTime]
(
	
)
RETURNS DATETIME
AS
BEGIN
	RETURN dateadd(WW,-1,getdate())
END
