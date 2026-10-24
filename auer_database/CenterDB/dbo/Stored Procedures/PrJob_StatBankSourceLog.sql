
-- =============================================
-- Author:		Jason
-- Create date: 2019/03/27
-- Description:	回傳BanksourceLog 新增PlatformID AreaID 對應 寫到新的[Stat].[StatisticsBankSourceLog_New]
-- =============================================
CREATE PROCEDURE [dbo].[PrJob_StatBankSourceLog]
(
	@dtStatTime		DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Type	TINYINT

	SET	@dtStatTime = ISNULL(@dtStatTime,GETDATE())
	
	DECLARE @LogStartTime	DATETIME
	DECLARE @LogEndTime		DATETIME
	DECLARE @TempDates		DATETIME

	IF (DATEPART(HOUR,@dtStatTime) = 0) AND (DATEPART(MINUTE,@dtStatTime) < 10)
	BEGIN
		SET @LogStartTime		= DATEADD(DAY,-30,DATEDIFF(DAY,0,@dtStatTime))
		SET @LogEndTime			= DATEADD(DAY,0,DATEDIFF(DAY,0,@dtStatTime))
	END
	ELSE
	BEGIN
		SET @LogStartTime		= DATEADD(DAY,0,DATEDIFF(DAY,0,@dtStatTime))
		SET @LogEndTime			= DATEADD(DAY,1,DATEDIFF(DAY,0,@dtStatTime))
	END

	/* 新作法 */
	----------------------------------------------------------------------------------------------------------------------
	DECLARE @Temp_BankSourceLog_New	TABLE ([PlatformID] INT,[AreaID] INT,[SourceTypeID] INT,[StatTime] DATETIME,[Amount] BIGINT)

	--新做法使用
	SET @Type	=	2

	INSERT INTO @Temp_BankSourceLog_New
	EXEC [LogDB].[dbo].[PrWeb_Stat_GetBankSourceLog]
		@Type			= @Type,
		@dtStatTime		= @LogStartTime,		
		@dtEndTime		= @LogEndTime

	MERGE [Stat].[BankSourceLog_New] AS A
	USING (
				SELECT	DISTINCT	PlatformID = PlatformID,
									AreaID = AreaID,
									SourceID = SourceTypeID,
									Amount = ISNULL(Amount,0),
									StatTime = StatTime
				FROM @Temp_BankSourceLog_New AS A
		) AS B ON (A.[StatTime] = B.[StatTime] AND A.SourceID = B.SourceID AND A.PlatformID = B.PlatformID AND A.AreaID = B.AreaID)
	WHEN MATCHED THEN
		UPDATE SET	A.Amount = B.Amount
	WHEN NOT MATCHED THEN
		INSERT (PlatformID,	AreaID,	SourceID,	Amount,	StatTime)
		VALUES
			(
				PlatformID,	AreaID,	B.SourceID,	ISNULL(Amount,0),StatTime
			);
	----------------------------------------------------------------------------------------------------------------------


END