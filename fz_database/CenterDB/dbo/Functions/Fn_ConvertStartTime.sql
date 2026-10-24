-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<获取查询兑换记录时间范围>
-- =============================================
CREATE FUNCTION [dbo].[Fn_ConvertStartTime]
(
	
)
RETURNS DATETIME
AS
BEGIN
	RETURN dateadd(dd,-1,getdate())
END
