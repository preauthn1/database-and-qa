-- =============================================
-- Author:		Mars
-- Create date: 2019/09/26
-- Description:	回傳BanksourceLog #406 保險箱統計改為LogDB計算及同步更新CenterDB
--	2019/09/26	Mars		新增PlatformID AreaID 對應 寫到新的[Stat].[StatisticsBankSourceLog_New]
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetBankSourceLog]
(
	@Type			TINYINT = 1,		-- 1:原作法 2:新作法(會有PlatformID AreaID對應關係)
	@dtStatTime		DATETIME = NULL,		
	@dtEndTime		DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @StatTime		DATETIME = @dtStatTime		
	DECLARE @EndTime		DATETIME = @dtEndTime

	/*  回傳統計紀錄  */
	IF(@Type = 1)
	BEGIN
		SELECT	[SourceTypeID], [StatTime], [Amount] 
		FROM [Stat].[StatisticsBankSourceLog_New] WITH (NOLOCK)
		WHERE
			StatTime >= @StatTime
			AND StatTime  < @dtEndTime
	END
	ELSE
	BEGIN
		SELECT	[PlatformID], [AreaID], [SourceTypeID], [StatTime], [Amount] 
		FROM [Stat].[StatisticsBankSourceLog_New] WITH (NOLOCK)
		WHERE
			StatTime >= @StatTime
			AND StatTime  < @dtEndTime
	END
END