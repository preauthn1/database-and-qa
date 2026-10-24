USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_FreeSpinRead')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_FreeSpinRead] AS BEGIN RETURN END'
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
-- 2019/08/22	Eddie	調整對應欄位和參數(ServerID -> GameID, add FlagID)
-- 2019/09/11	Eddie/White	增加回傳欄位(OriginID, WinTimes), read時不reset
-- 2019/11/07	White	增加FreeSpinRecord的欄位(Data)
-- 2019/12/13	Louis	Slot_FreeSpinRecord欄位IsCoupon移除，調整對應語法
-- 2020/01/08	Louis	調整WinMoney取得方式，直接取Slot_FreeSpinRecord.WinMoney
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_FreeSpinRead]
	@intUserID		INT,		-- 用户ID
	@intGameID		INT,		-- GameID
	@intFlagID		INT,		-- FlagID
	@chvMsg			VARCHAR(100)	OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	--判斷沒有資料時先建立資料
	IF NOT EXISTS (SELECT * FROM [Game].[Slot_FreeSpinRecord] WITH (NOLOCK) WHERE UserID = @intUserID AND GameID = @intGameID AND FlagID = @intFlagID)
	BEGIN
		INSERT INTO [Game].[Slot_FreeSpinRecord]
			([UserID],[GameID],[FlagID],[UserBet],[FreeSpinGroup],[Times],[ChooseRate],[OriginID],[WinTimes],[Data],[WinMoney],[PatternID])
		VALUES
			(@intUserID,@intGameID,@intFlagID,0,0,0,0,0,0,'',0,0)
	END

	SELECT [UserID],[GameID],[FlagID],[OriginID],[FreeSpinGroup],[Times],[UserBet],[ChooseRate],[WinMoney],[WinTimes],[Data],[PatternID]
	FROM [Game].[Slot_FreeSpinRecord] WITH(NOLOCK)
	WHERE UserID = @intUserID AND GameID = @intGameID AND FlagID = @intFlagID

	SET @chvMsg = '操作成功'
	
	RETURN 1	
	
END