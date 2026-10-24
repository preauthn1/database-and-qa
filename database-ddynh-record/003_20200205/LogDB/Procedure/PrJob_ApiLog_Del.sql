USE [LogDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_ApiLog_Del')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_ApiLog_Del] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ｌouis
-- Create date: 2020/03/31
-- Description:	Purfe PI Log相關資料表資料
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_ApiLog_Del]
AS
BEGIN
	DECLARE @dtDate DATETIME = CONVERT(DATE,GETDATE() -30)
	DECLARE @dtDeleteDate DATETIME

	--ApiRequestLog_JobApi
	SELECT @dtDeleteDate = DATEADD(DAY,1,CONVERT(DATE,MIN([CreateTime]))) FROM [LogDB].[dbo].[ApiRequestLog_JobApi] WHERE [CreateTime] < @dtDate
	WHILE @dtDeleteDate <= @dtDate
	BEGIN
		DELETE [LogDB].[dbo].[ApiRequestLog_JobApi] WHERE [CreateTime] < @dtDeleteDate
		SET @dtDeleteDate = DATEADD(DAY,1,@dtDeleteDate)
	END
	--ApiRequestLog_GamePlayApi
	SELECT @dtDeleteDate = DATEADD(DAY,1,CONVERT(DATE,MIN([CreateTime]))) FROM [LogDB].[dbo].[ApiRequestLog_GamePlayApi] WHERE [CreateTime] < @dtDate
	WHILE @dtDeleteDate <= @dtDate
	BEGIN
		DELETE [LogDB].[dbo].[ApiRequestLog_GamePlayApi] WHERE [CreateTime] < @dtDeleteDate
		SET @dtDeleteDate = DATEADD(DAY,1,@dtDeleteDate)
	END
	--ApiRequestLog_GameApi
	SELECT @dtDeleteDate = DATEADD(DAY,1,CONVERT(DATE,MIN([CreateTime]))) FROM [LogDB].[dbo].[ApiRequestLog_GameApi] WHERE [CreateTime] < @dtDate
	WHILE @dtDeleteDate <= @dtDate
	BEGIN
		DELETE [LogDB].[dbo].[ApiRequestLog_GameApi] WHERE [CreateTime] < @dtDeleteDate
		SET @dtDeleteDate = DATEADD(DAY,1,@dtDeleteDate)
	END
	--ApiRequestLog_ExternalApi
	SELECT @dtDeleteDate = DATEADD(DAY,1,CONVERT(DATE,MIN([CreateTime]))) FROM [LogDB].[dbo].[ApiRequestLog_ExternalApi] WHERE [CreateTime] < @dtDate
	WHILE @dtDeleteDate <= @dtDate
	BEGIN
		DELETE [LogDB].[dbo].[ApiRequestLog_ExternalApi] WHERE [CreateTime] < @dtDeleteDate
		SET @dtDeleteDate = DATEADD(DAY,1,@dtDeleteDate)
	END
	--ApiRequestLog
	SELECT @dtDeleteDate = DATEADD(DAY,1,CONVERT(DATE,MIN([CreateTime]))) FROM [LogDB].[dbo].[ApiRequestLog] WHERE [CreateTime] < @dtDate
	WHILE @dtDeleteDate <= @dtDate
	BEGIN
		DELETE [LogDB].[dbo].[ApiRequestLog] WHERE [CreateTime] < @dtDeleteDate
		SET @dtDeleteDate = DATEADD(DAY,1,@dtDeleteDate)
	END

END
GO
