CREATE TABLE [Game].[Slot_LightningGameRecord] (
    [ID]     BIGINT IDENTITY (1, 1) NOT NULL,
    [UserID] INT    NULL,
    [GameID] INT    NULL,
    [FlagID] INT    NULL,
    [Data]   TEXT   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_Slot_LightningGameRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [GameID] ASC, [FlagID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲資料(自行做字串處理)', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_LightningGameRecord', @level2type = N'COLUMN', @level2name = N'Data';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間類型ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_LightningGameRecord', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_LightningGameRecord', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_LightningGameRecord', @level2type = N'COLUMN', @level2name = N'UserID';

