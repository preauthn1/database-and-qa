USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_DeferredAwardRecord')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_DeferredAwardRecord] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Louis
-- Create date: 2019/12/27
-- Description:	寫入Slot_DeferredAward資料
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_DeferredAwardRecord]
	@intUserID			INT,			-- 用户ID
	@intGameID		    INT,			-- GameID
    @intFlagID		    INT,			-- FlagID
    @intOriginID        INT,			-- 規則ID
    @chvAwardType		NVARCHAR(50),	-- AwardType
    @txtData		    TEXT = '',		-- Json Data
	@intPatternID		INT = 0,		-- 模式ID		
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN

    -- INSERT the record
    INSERT INTO [Game].[Slot_DeferredAward] ([UserID], [GameID], [FlagID], [OriginID], [AwardType], [CreateTime], [Data], [PatternID])
    VALUES (@intUserID, @intGameID, @intFlagID, @intOriginID, @chvAwardType, GETDATE(), @txtData, @intPatternID)

    SET @chvMsg = '新增成功'
    
RETURN 1

END