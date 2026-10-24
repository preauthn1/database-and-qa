USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_SelectGameRecord')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_SelectGameRecord] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Eddie/White
-- Create date: 2019/09/11
-- Description:	寫Slot_SelectGameRecord資料
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_SelectGameRecord]
	@intUserID			INT,		-- 用户ID
	@intGameID		    INT,		-- GameID
    @intFlagID		    INT,		-- FlagID
	@intOriginID        INT,        -- 機率表ID
    @intTimes           INT,        -- 剩餘次數
    @txtData           TEXT,        -- 補充資料(自行做字串處理)
	@intPatternID		INT = 0,	-- 模式ID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN

    -- Task
    -- Check Record Exist, Not Exist -> Insert, Exist -> Check OriginID is Equal then Update Times
    IF NOT EXISTS (SELECT TOP 1 1 FROM [Game].[Slot_SelectGameRecord] WITH (NOLOCK) WHERE UserID = @intUserID AND GameID = @intGameID AND FlagID = @intFlagID)
        BEGIN
            -- INSERT the record
            INSERT INTO [Game].[Slot_SelectGameRecord]
                ([UserID], [GameID], [FlagID], [OriginID], [Times], [Data], [PatternID])
            VALUES
                (@intUserID, @intGameID, @intFlagID, @intOriginID, @intTimes, @txtData, @intPatternID)
            -- OK
                -- chvMsg = 操作成功
            -- !OK
                -- chvMsg = 操作失敗
        END
    ELSE
        BEGIN
            -- Check OriginID is Equal
            UPDATE [Game].[Slot_SelectGameRecord]
            SET
                [Times] = @intTimes
				,[PatternID] = @intPatternID
            WHERE
                [UserID] = @intUserID
                AND
                [GameID] = @intGameID
                AND
                [FlagID] = @intFlagID
                AND
                [OriginID] = @intOriginID

            -- eq
                -- Update Times
                -- chvMsg = 操作成功
            -- !eq
                -- Do nothing
                -- chvMsg = 操作失敗
        END

SET @chvMsg = '操作成功'
RETURN 1

END