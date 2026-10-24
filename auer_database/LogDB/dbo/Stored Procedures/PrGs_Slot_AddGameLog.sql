
-- =============================================
-- Author:		Jason
-- Create date: 2019/05/24
-- Description:	給CenterDB SP呼叫用 寫入遊戲歷程
-- 2019/06/20 修改 logid 格式YMDHM 加流水號共16碼
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Slot_AddGameLog]
(
	@intUserID			INT,
	@intPlatformID		INT,
	@intAreaID			INT,
	@intGameID			INT,
	@intServerID		INT,
	@lngCurrentAmount	BIGINT,
	@lngCurrentCoupon	BIGINT,
	@lngBetMoney		BIGINT,
	@lngBetCoupon		BIGINT,
	@lngWinMoney		BIGINT,
	@lngFinalScore		BIGINT,
	@lngFinalCoupon		BIGINT,
	@intGameType		TINYINT,
	@intLogType			TINYINT,
	@chvGameData		VARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @NowTime	DATETIME = GETDATE()

	/*  取號  */
	DECLARE @TempLogID	INT
	DECLARE @LogID	BIGINT
	DECLARE @YMD	VARCHAR(6)
	DECLARE @HM	    VARCHAR(4)

	EXEC [dbo].[PrWeb_Slot_GetSequence]
		@intLogID = @TempLogID OUTPUT

	SET @YMD = RIGHT(CONVERT(VARCHAR(10),@NowTime,112),6)
	SET @HM = LEFT(Replace(Convert(varchar(8),@NowTime,108),':',''), 4)

	SELECT	@LogID = CAST(@YMD + @HM + RIGHT(REPLICATE('0',16) + CAST(@TempLogID AS NVARCHAR),6) AS BIGINT)


	INSERT INTO [Game].[SlotGameHistoryLog]
		(	
			[LogID],[CreateTime],[PlatformID],[AreaID],[GameID],[ServerID],[UserID],
			[CurrentAmount],[CurrentCoupon],[BetMoney],[BetCoupon],[WinMoney],[FinalScore],[FinalCoupon],[GameType],[LogType],[GameData]
		)
	VALUES
		(
			@LogID,@NowTime,@intPlatformID,@intAreaID,@intGameID,@intServerID,@intUserID,
			@lngCurrentAmount,@lngCurrentCoupon,@lngBetMoney,@lngBetCoupon,@lngWinMoney,@lngFinalScore,@lngFinalCoupon,@intGameType,@intLogType,@chvGameData
		)

	RETURN
END