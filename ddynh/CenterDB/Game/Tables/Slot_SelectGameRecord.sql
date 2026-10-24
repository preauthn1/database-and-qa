CREATE TABLE [Game].[Slot_SelectGameRecord] (
    [ID]       BIGINT IDENTITY (1, 1) NOT NULL,
    [UserID]   INT    NOT NULL,
    [GameID]   INT    NOT NULL,
    [FlagID]   INT    NOT NULL,
    [OriginID] INT    NOT NULL,
    [Times]    INT    NULL,
    [Data]     TEXT   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_Slot_SelectGameRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [GameID] ASC, [FlagID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'補充資料(自行做字串處理)', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'Data';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'剩餘次數', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'Times';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'機率表ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'OriginID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間類型ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'UserID';

