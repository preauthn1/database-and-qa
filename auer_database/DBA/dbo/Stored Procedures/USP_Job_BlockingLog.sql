
-- =============================================
-- Author:		Jason
-- Create date: 2018/03/16
-- Description:	Blocking紀錄
-- =============================================
CREATE PROCEDURE [dbo].[USP_Job_BlockingLog]
AS
BEGIN
	
	SET NOCOUNT ON;

	/* 變數設定  */
	------------------------------------------------------------------
	DECLARE @LogStartTime	DATETIME
	DECLARE @LogEndTime		DATETIME
	DECLARE @TimeRange		INT

	DECLARE @Temp_BlockingLog	TABLE
		(
			[DBName] [varchar](128) ,
			[request_session_id] [int] ,
			[blocking_session_id] [int] ,
			[BlockedObjectName] [varchar](128) ,
			[resource_type] [varchar](128) ,
			[RequestingText] [nvarchar](max) ,
			[BlockingText] [nvarchar](max) ,
			[Request_mode] [varchar](128) ,
			[Wait_duration_ms] [int] ,
			[Wait_type] [varchar](128)
		)

	SET @TimeRange		=	90
	SET @LogStartTime	=	DATEADD(SECOND,-(@TimeRange),GETDATE())
	SET @LogEndTime		=	GETDATE()
	------------------------------------------------------------------


	/* 寫入90秒內紀錄暫存 */
	------------------------------------------------------------------
	INSERT INTO @Temp_BlockingLog
	SELECT	DBName,
			request_session_id,
			blocking_session_id,
			BlockedObjectName,
			resource_type,
			RequestingText,
			BlockingText,
			request_mode,
			wait_duration_ms,
			wait_type
	FROM [DBA].[dbo].[BlockingLog] WITH (NOLOCK)
	WHERE
		@LogStartTime <= [LogTime]
		AND @LogEndTime > [LogTime]
	------------------------------------------------------------------


	/* 寫入紀錄 */
	------------------------------------------------------------------
	INSERT INTO [DBA].[dbo].[BlockingLog]
		([LogTime],[DBName],[request_session_id],[blocking_session_id],[BlockedObjectName],[resource_type],[RequestingText],[BlockingText],[Request_mode],[Wait_duration_ms],[Wait_type])
	SELECT	@LogEndTime AS LogTime,
			DBName,
			request_session_id,
			blocking_session_id,
			BlockedObjectName,
			resource_type,
			RequestingText,
			BlockingText,
			request_mode,
			wait_duration_ms,
			wait_type
	FROM (
			SELECT	db.name AS DBName,
					dtl.request_session_id,
					dowt.blocking_session_id,
					OBJECT_NAME(pt.OBJECT_ID) AS BlockedObjectName,
					dtl.resource_type,
					dest1.TEXT AS RequestingText,
					dest2.TEXT AS BlockingText,
					dtl.request_mode,
					dowt.wait_duration_ms,
					dowt.wait_type
			FROM sys.dm_tran_locks AS dtl
			INNER JOIN sys.databases db ON db.database_id = dtl.resource_database_id
			INNER JOIN sys.dm_os_waiting_tasks AS dowt ON dtl.lock_owner_address = dowt.resource_address
			INNER JOIN sys.partitions AS pt ON pt.hobt_id = dtl.resource_associated_entity_id
			INNER JOIN sys.dm_exec_connections dec1 ON dec1.session_id = dtl.request_session_id
			INNER JOIN sys.dm_exec_connections dec2 ON dec2.session_id = dowt.blocking_session_id
			CROSS APPLY sys.dm_exec_sql_text(dec1.most_recent_sql_handle) AS dest1
			CROSS APPLY sys.dm_exec_sql_text(dec2.most_recent_sql_handle) AS dest2
			EXCEPT
			SELECT	DBName,
					request_session_id,
					blocking_session_id,
					BlockedObjectName,
					resource_type,
					RequestingText,
					BlockingText,
					request_mode,
					wait_duration_ms,
					wait_type
			FROM @Temp_BlockingLog
		) AS A
	------------------------------------------------------------------

	RETURN
END
