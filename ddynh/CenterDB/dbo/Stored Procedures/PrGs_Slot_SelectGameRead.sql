

-- =============================================
-- Author:  Eddie/White
-- Create date: 2019/09/11
-- Description:	讀取Slot_SelectGameRecord資料
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Slot_SelectGameRead]
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
        [Data]
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