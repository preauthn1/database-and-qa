USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_FreeSpinRecord')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_FreeSpinRecord] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  jason
-- Create date: 2019/05/13
-- Description:	寫入FreeSpin紀錄
-- 2019/06/25 增加是否禮碼投注
-- 2019/08/22	Eddie	調整對應欄位和參數(ServerID -> GameID, add FlagID)
-- 2019/09/11	Eddie/White	增加回傳欄位(OriginID, WinTimes)
-- 2019/11/07	White	增加FreeSpinRecord的欄位(Data)
-- 2019/12/13	Louis	Slot_FreeSpinRecord欄位IsCoupon移除，調整對應語法
-- 2020/01/08	Louis	調整WinMoney儲存，直接存在Slot_FreeSpinRecord
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_FreeSpinRecord]
(
	@intUserID 				INT,				-- 用户ID
	@intGameID 				INT,		  		-- GameID
	@intFlagID 				INT,		  		-- FlagID
	@intUserBet 			INT,				-- 玩家下注金額
	@intFreeSpinGroup 		INT,				-- FreeSpin群組
	@intTimes 				INT,				-- FreeSpin次數
	@intChooseRate 			INT,				-- 玩家選擇賠率
	@lngWinMoney			BIGINT, 			-- 玩家輸贏金額
	@tnyIsCoupon			TINYINT = NULL,		-- 目前已不會使用，先保留等待AP端拔除後在移除
	@intOriginID			INT, 				-- 機率表ID
	@intWinTimes			INT, 				-- 累計贏的次數
	@txtData				NVARCHAR(MAX) = '', -- 額外資訊
	@intPatternID			INT = 0,			-- 模式ID
	@chvMsg 				VARCHAR(100) OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	--DECLARE @GameType INT = 1 --1:freespin 2:dfdc
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM [Game].[Slot_FreeSpinRecord] WITH (NOLOCK) WHERE UserID = @intUserID AND [GameID] = @intGameID AND [FlagID] = @intFlagID)
	BEGIN
		INSERT INTO [Game].[Slot_FreeSpinRecord]
			([UserID],[GameID],[FlagID],[UserBet],[FreeSpinGroup],[Times],[ChooseRate],[OriginID],[WinTimes],[Data],[WinMoney],[PatternID])
		VALUES
			(@intUserID,@intGameID,@intFlagID,@intUserBet,@intFreeSpinGroup,@intTimes,@intChooseRate,@intOriginID,@intWinTimes,@txtData,@lngWinMoney,@intPatternID)
	END
	ELSE
	BEGIN
		UPDATE [Game].[Slot_FreeSpinRecord]
		SET 
			[UserBet] = @intUserBet,
			[FreeSpinGroup] = @intFreeSpinGroup,
			[Times] = @intTimes,
			[ChooseRate] = @intChooseRate,
			[OriginID] = @intOriginID,
			[WinTimes] = @intWinTimes,
			[Data] = @txtData,
			[WinMoney] = @lngWinMoney,
			[PatternID] = @intPatternID
		WHERE
			[UserID] = @intUserID
			AND 
			[GameID] = @intGameID
			AND 
			[FlagID] = @intFlagID
	END

	IF(@@ROWCOUNT <> 1)
	BEGIN
		SET @chvMsg = '操作失敗 : 更新個人FreeSpin失敗'
		RETURN -1
	END

	SET @chvMsg = '操作成功'
	
	RETURN 1	
	
END