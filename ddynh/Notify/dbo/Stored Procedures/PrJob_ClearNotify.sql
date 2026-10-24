-- =============================================
-- Author:		<xxx>
-- Create date: <15/09/29>
-- Description:	<清理通知数据>
--	2018/06/13	Jason	#451 後台增加短信(SMS)發送狀態查詢 排程每天清理超過30天記錄
--	2019/12/04	Louis	修改清理記錄方式(Truncate Partition Table)
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_ClearNotify]
AS
BEGIN
	SET NOCOUNT ON
	TRUNCATE TABLE Notify.Attr
	--TRUNCATE TABLE Notify.EmailQueue //disable by alan, because EmailQueue table not exist

	DECLARE @dtFirstDate DATETIME
	SELECT TOP 1 @dtFirstDate = CAST(v.value AS DATETime)
	FROM sys.partition_range_values AS v 
	LEFT JOIN sys.partition_functions AS f ON v.function_id=f.function_id 
	WHERE f.name = 'Fn_Day'
	ORDER BY value
	
	WHILE @dtFirstDate < DATEADD(month,-1,GETDATE())
	BEGIN		
		PRINT CONVERT(VARCHAR,@dtFirstDate,120)
		--清除多餘分區數據
		TRUNCATE TABLE [Notify].[Notify] WITH(Partitions(1))
		TRUNCATE TABLE [Notify].[SMSVCode] WITH(Partitions(1))

		--合併分區								
		ALTER PARTITION FUNCTION Fn_Day() MERGE RANGE(@dtFirstDate)
		
		SET @dtFirstDate = DATEADD(dd,1,@dtFirstDate)
	END
	RETURN 1
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrJob_ClearNotify] TO [xbuser]
    AS [dbo];

