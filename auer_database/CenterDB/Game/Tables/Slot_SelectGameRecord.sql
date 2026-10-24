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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'產ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'笴栏ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'┬丁摸ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'诀瞯ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'OriginID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'逞緇Ω计', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'Times';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'干戈(︽暗﹃矪瞶)', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_SelectGameRecord', @level2type = N'COLUMN', @level2name = N'Data';

