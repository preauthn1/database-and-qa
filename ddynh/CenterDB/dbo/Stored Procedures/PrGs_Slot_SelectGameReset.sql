

-- =============================================
-- Author:  Eddie/White
-- Create date: 2019/09/11
-- Description:	清除Slot_SelectGameRecord資料
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Slot_SelectGameReset]
	@intUserID			INT,		-- 用户ID
	@intGameID		    INT,		-- GameID
	@intFlagID		    INT,		-- FlagID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN

    -- Task
    -- Delete Slot_SelectGameRecord Record
    DELETE FROM [Game].[Slot_SelectGameRecord]
		WHERE 
        [UserID] = @intUserID
        AND
        [GameID] = @intGameID
        AND
        [FlagID] = @intFlagID

SET @chvMsg = '操作成功'
RETURN 1

END