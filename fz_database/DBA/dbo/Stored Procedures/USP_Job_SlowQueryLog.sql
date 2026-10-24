-- =============================================
-- Author:		Jason
-- Create date: 2018/03/16
-- Description:	SlowQuery紀錄
-- =============================================
CREATE PROCEDURE [dbo].[USP_Job_SlowQueryLog]
AS
BEGIN
	
	SET NOCOUNT ON;


	/* 寫入紀錄 */
	------------------------------------------------------------------
	INSERT INTO [DBA].[dbo].[SlowQueryLog]
		(
			[session_id],[login_time],[host_name],[program_name],[login_name],[nt_domain],[nt_user_name],[status],[cpu_time],[memory_usage],[total_elapsed_time],
			[last_request_start_time],[last_request_end_time],[reads],[writes],[logical_reads],[command],[plan_handle],[sql_handle],[blocking_session_id],[sql_text]
		)
	SELECT	a.session_id,
			a.login_time,
			a.host_name,
			a.program_name,
			a.login_name,
			a.nt_domain,
			a.nt_user_name,
			a.status,
			a.cpu_time,
			a.memory_usage,
			a.total_elapsed_time,
			a.last_request_start_time,
			a.last_request_end_time,
			b.reads,
			b.writes,
			b.logical_reads,
			b.command,
			b.plan_handle,
			b.sql_handle,
			b.blocking_session_id,
			d.text
	FROM [sys].[dm_exec_sessions] AS a
		INNER JOIN [sys].[dm_exec_requests] AS b ON a.session_id = b.session_id
		INNER JOIN sys.dm_exec_cached_plans AS c ON c.plan_handle = b.plan_handle
		CROSS APPLY sys.dm_exec_sql_text(c.plan_handle) AS d
	WHERE
		--login_name <> 'sa'
		--AND a.total_elapsed_time > 3000000	--超過3秒
		 a.total_elapsed_time > 1000000	--超過1秒
	------------------------------------------------------------------

	RETURN
END
