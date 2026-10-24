USE [msdb]
GO

IF EXISTS(SELECT * FROM msdb.dbo.sysjobs WHERE name = N'經典21點重置系統水池')
BEGIN
	EXEC msdb.dbo.sp_delete_job @job_name=N'經典21點重置系統水池', @delete_unused_schedule=1
END
GO
