
-- =============================================
-- Author:		Jason
-- Create date: 2018/03/16
-- Description:	Query讀取量紀錄
-- =============================================
CREATE PROCEDURE [dbo].[USP_Job_ExecutionReadsLog]
AS
BEGIN
	
	SET NOCOUNT ON;

	/* 寫入300秒內紀錄暫存 */
	------------------------------------------------------------------
	INSERT INTO [dbo].[ExecutionLog]
		(
			[objtype],
			[plan_handle],
			[sql_handle],
			[creation_time],
			[last_execution_time],
			[execution_time],
			[avg_physical_reads],
			[avg_logical_reads],
			[avg_logical_writes],
			[avg_elapsed_time],
			[sql_text]
		)
	SELECT	p.objtype,
			p.plan_handle,
			s.sql_handle,
			s.creation_time,
			s.last_execution_time,
			s.execution_count,
			total_physical_reads / execution_count AS avg_physical_reads,
			total_logical_reads / execution_count AS avg_logical_reads,
			total_logical_writes / execution_count AS avg_logical_writes,
			total_elapsed_time / execution_count / 1000000 AS avg_elapsed_time,
			t.text as SQL_Text
	FROM sys.dm_exec_cached_plans AS p
	INNER JOIN sys.dm_exec_query_stats AS s
	   ON p.plan_handle = s.plan_handle
	CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
	WHERE
		t.dbid IS NOT NULL
		AND dbid < 32767
		AND (
				((total_physical_reads / execution_count) > 5000)
				OR
				((total_logical_reads / execution_count) > 5000)
				OR
				((total_elapsed_time / execution_count / 1000000) > 3)
			)
	ORDER BY s.last_execution_time DESC
	------------------------------------------------------------------

	RETURN
END
