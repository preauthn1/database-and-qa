
-- =============================================
-- Author:  Eddie/White
-- Create date: 2019/09/11
-- Description:	寫Slot_SelectGameRecord資料
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Slot_SelectGameRecord]
	@intUserID			INT,		-- 用户ID
	@intGameID		    INT,		-- GameID
    @intFlagID		    INT,		-- FlagID
	@intOriginID        INT,        -- 機率表ID
    @intTimes           INT,        -- 剩餘次數
    @txtData           TEXT,        -- 補充資料(自行做字串處理)
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN

    -- Task
    -- Check Record Exist, Not Exist -> Insert, Exist -> Check OriginID is Equal then Update Times
    IF NOT EXISTS (SELECT TOP 1 1 FROM [Game].[Slot_SelectGameRecord] WITH (NOLOCK) WHERE UserID = @intUserID AND GameID = @intGameID AND FlagID = @intFlagID)
        BEGIN
            -- INSERT the record
            INSERT INTO [Game].[Slot_SelectGameRecord]
                ([UserID], [GameID], [FlagID], [OriginID], [Times], [Data])
            VALUES
                (@intUserID, @intGameID, @intFlagID, @intOriginID, @intTimes, @txtData)
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
