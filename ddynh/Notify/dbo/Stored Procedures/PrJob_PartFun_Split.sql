-- =============================================
-- Author:		<Louis>
-- Create date: <2019-12-04>
-- Description:	<擴充分區函数> 每日分區擴充(F_Day)
-- =============================================
Create PROCEDURE [dbo].[PrJob_PartFun_Split]
	
AS
BEGIN

	DECLARE @dtLastDate DATETime
	SELECT TOP 1 
	@dtLastDate = CAST(v.value AS DATETime)
	--f.name,v.value
	FROM sys.partition_range_values AS v 
	LEFT JOIN sys.partition_functions AS f ON v.function_id=f.function_id 
	WHERE f.name = 'Fn_Day'
	ORDER BY value DESC
	PRINT CONVERT(VARCHAR,@dtLastDate,120)

	WHILE @dtLastDate < DATEADD(dd,30,GETDATE())
	BEGIN
		SET @dtLastDate = DATEADD(dd,1,@dtLastDate)		
		ALTER PARTITION SCHEME S_Day NEXT USED [Primary]		
		ALTER PARTITION FUNCTION Fn_Day() SPLIT RANGE(@dtLastDate)								
	END				
	
END