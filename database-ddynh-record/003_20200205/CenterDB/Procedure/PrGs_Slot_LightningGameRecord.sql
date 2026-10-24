USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_LightningGameRecord')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_LightningGameRecord] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Eddie/White
-- Create date: 2019/10/09
-- Description:	更新Slot_LightningGameRecord資料
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_LightningGameRecord]
	@intUserID			INT,		-- 用户ID
	@intGameID		    INT,		-- GameID
    @intFlagID		    INT,		-- FlagID
    @txtData		    TEXT,		-- Json Data
	@intPatternID		INT = 0,	-- 模式ID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN
    -- Task
    -- Check Record Exist, Not Exist -> Insert, Exist -> Check OriginID is Equal then Update Times
    IF NOT EXISTS (SELECT TOP 1 1 FROM [Game].[Slot_LightningGameRecord] WITH (NOLOCK) WHERE UserID = @intUserID AND GameID = @intGameID AND FlagID = @intFlagID)
        BEGIN
            IF datalength(@txtData) = 0
                BEGIN
                    SET @chvMsg = '無輸入資料'
                    RETURN -1
                END
            ELSE
                BEGIN
                    -- INSERT the record
                    INSERT INTO [Game].[Slot_LightningGameRecord]
                        ([UserID], [GameID], [FlagID], [Data], [PatternID])
                    VALUES
                        (@intUserID, @intGameID, @intFlagID, @txtData, @intPatternID)
                END
        END
    ELSE
        BEGIN
            IF datalength(@txtData) = 0
                -- No Data, DELETE the record
                BEGIN
                    DELETE FROM [Game].[Slot_LightningGameRecord]
                    WHERE
                        [UserID] = @intUserID
                    AND
                        [GameID] = @intGameID
                    AND
                        [FlagID] = @intFlagID
                END
            ELSE
                -- Has Data, UPDATE the record
                BEGIN
                    UPDATE [Game].[Slot_LightningGameRecord]
                    SET
                        [Data] = @txtData
						,[PatternID] = @intPatternID
                    WHERE
                        [UserID] = @intUserID
                    AND
                        [GameID] = @intGameID
                    AND
                        [FlagID] = @intFlagID
                END
        
        END
    

	SET @chvMsg = '操作成功'
	RETURN 1

END
