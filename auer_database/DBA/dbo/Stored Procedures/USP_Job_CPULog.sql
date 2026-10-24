
-- =============================================
-- Author:		Jason
-- Create date: 2018/03/15
-- Description:	CPU使用紀錄
-- =============================================
CREATE PROCEDURE [dbo].[USP_Job_CPULog]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @StartTime	DATETIME
	DECLARE @EndTime	DATETIME

	DECLARE @ts_now BIGINT = (SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info); 
	DECLARE @Temp_Log		TABLE (SQL_Pct INT,Idle_Pct INT,Other_Pct INT,EventTime DATETIME)
	DECLARE @Temp_NowLog	TABLE (SQL_Pct INT,Idle_Pct INT,Other_Pct INT,EventTime DATETIME)

	SET @StartTime	=	DATEADD(MINUTE,-30,GETDATE())
	SET @EndTime	=	GETDATE()


	INSERT INTO @Temp_Log
	SELECT	TOP (100) SQL_Pct,
			Idle_Pct,
			Other_Pct,
			EventTime
	FROM [DBA].[dbo].[CPUEvent]
	WHERE
		@StartTime <= EventTime
		AND @EndTime > EventTime
	ORDER BY EventTime DESC

	INSERT INTO @Temp_NowLog
	SELECT TOP(30)	SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
					SystemIdle AS [System Idle Process], 
					100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
					DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
	FROM ( 
			SELECT	record.value('(./Record/@id)[1]', 'int') AS record_id, 
					record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle], 
					record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int') AS [SQLProcessUtilization], [timestamp] 
			FROM ( 
					SELECT	[timestamp], CONVERT(xml, record) AS [record] 
					FROM sys.dm_os_ring_buffers 
					WHERE
						ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
						AND record LIKE '%<SystemHealth>%') AS x 
		) AS y 
	ORDER BY record_id DESC;

	INSERT INTO [DBA].[dbo].[CPUEvent]
	SELECT	SQL_Pct,
			Idle_Pct,
			Other_Pct,
			EventTime
	FROM (
			SELECT	SQL_Pct,
					Idle_Pct,
					Other_Pct,
					CONVERT(VARCHAR(23),EventTime,120) AS EventTime
			FROM @Temp_NowLog
			EXCEPT
			SELECT	SQL_Pct,
					Idle_Pct,
					Other_Pct,
					CONVERT(VARCHAR(23),EventTime,120) AS EventTime
			FROM @Temp_Log
		) AS A
	ORDER BY EventTime ASC
END
