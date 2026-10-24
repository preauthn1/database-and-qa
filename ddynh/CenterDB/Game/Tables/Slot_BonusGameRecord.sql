CREATE TABLE [Game].[Slot_BonusGameRecord] (
    [ID]       BIGINT IDENTITY (1, 1) NOT NULL,
    [UserID]   INT    NULL,
    [GameID]   INT    NULL,
    [FlagID]   INT    NULL,
    [OriginID] INT    NULL,
    [TurnID]   INT    NULL,
    [Location] INT    NULL,
    [BetMoney] INT    NULL,
    [BetRate]  INT    NULL,
    [Data]     TEXT   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_Slot_BonusGameRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [GameID] ASC, [FlagID] ASC, [OriginID] ASC, [TurnID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲資料(自行做字串處理)', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'Data';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'下注倍率', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'BetRate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'下注金額', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'BetMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'選擇位置', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'Location';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第幾次選擇', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'TurnID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'規則ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'OriginID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間類型ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_BonusGameRecord', @level2type = N'COLUMN', @level2name = N'UserID';

