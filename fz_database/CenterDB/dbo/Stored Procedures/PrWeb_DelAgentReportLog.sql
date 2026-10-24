

-- =============================================
-- Author: alan
-- Create date: 2019/4/14
-- Description: 刪除代理舉報內容
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_DelAgentReportLog]
@intID int
AS
BEGIN
	
	DELETE Agent.ReportLog
	WHERE [Id] = @intID

END

