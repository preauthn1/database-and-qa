USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_DeferredAwardRead')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_DeferredAwardRead] AS BEGIN RETURN END'
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
-- Description:	讀取Slot_DeferredAward 資料
-- 2020/03/13	Louis	#64增加PatternID處理
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_DeferredAwardRead]
	@intUserID			INT,			-- 用户ID
	@intGameID		    INT,			-- GameID
    @intFlagID		    INT,			-- FlagID
	@chvAwardType		NVARCHAR(50),	-- AwardType
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN
    -- Return Data From Slot_DeferredAwardRead
    SELECT 
        [UserID],
        [GameID],
        [FlagID],
        [OriginID],
		[AwardType],
		[CreateTime],
        [Data],
		[PatternID]
    FROM
        [Game].[Slot_DeferredAward]
    WHERE
        [UserID] = @intUserID
        AND
        [GameID] = @intGameID
        AND
        [FlagID] = @intFlagID
		AND
		[AwardType] = @chvAwardType
	ORDER BY ID
SET @chvMsg = '操作成功'
RETURN 1

END
