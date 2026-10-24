-- =============================================
-- Author:		Rory
-- Create date: 20190828
-- Description:	指令工作通知
-- =============================================
create PROCEDURE [dbo].[PrNs_GetCmdWorkerList]
AS
SET NOCOUNT ON
SELECT TOP 200 * INTO #temp_list 
FROM Notify.CmdWorker
WHERE Status = 0
ORDER BY CreateTime

UPDATE Notify.CmdWorker
SET Status = 1,
LastPostTime = GETDATE()
FROM #temp_list
WHERE Notify.CmdWorker.Id = #temp_list.Id

SELECT CommandType, ISNULL(SParam, '') AS SParam FROM #temp_list

DROP TABLE #temp_list

RETURN 1