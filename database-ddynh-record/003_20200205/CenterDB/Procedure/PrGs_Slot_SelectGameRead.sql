USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_SelectGameRead')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_SelectGameRead] AS BEGIN RETURN END'
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
-- Description:	讀取Slot_SelectGameRecord資料
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_SelectGameRead]
	@intUserID			INT,		-- 用户ID
	@intGameID		    INT,		-- GameID
    @intFlagID		    INT,		-- FlagID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN

    -- Task
    -- Return Data From Slot_SelectGameRecord
    SELECT 
        [UserID],
        [GameID],
        [FlagID],
        [OriginID],
        [Times],
        [Data],
		[PatternID]
    FROM
        [Game].[Slot_SelectGameRecord]
    WHERE
        [UserID] = @intUserID
        AND
        [GameID] = @intGameID
        AND
        [FlagID] = @intFlagID


SET @chvMsg = '操作成功'
RETURN 1

END
