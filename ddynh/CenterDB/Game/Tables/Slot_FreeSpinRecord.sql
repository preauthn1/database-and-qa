CREATE TABLE [Game].[Slot_FreeSpinRecord] (
    [ID]            BIGINT IDENTITY (1, 1) NOT NULL,
    [UserID]        INT    NOT NULL,
    [GameID]        INT    NOT NULL,
    [UserBet]       BIGINT NOT NULL,
    [FreeSpinGroup] INT    NOT NULL,
    [Times]         INT    NOT NULL,
    [ChooseRate]    INT    NOT NULL,
    [FlagID]        INT    NULL,
    [OriginID]      INT    CONSTRAINT [DF_Slot_FreeSpinRecord_OriginID] DEFAULT ((0)) NOT NULL,
    [WinTimes]      INT    CONSTRAINT [DF_Slot_FreeSpinRecord_WinTimes] DEFAULT ((0)) NOT NULL,
    [Data]          TEXT   NULL,
    CONSTRAINT [PK_Slot_FreeSpinRecord] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_Slot_FreeSpinRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [GameID] ASC, [FlagID] ASC)
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'額外資訊', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Slot_FreeSpinRecord', @level2type = N'COLUMN', @level2name = N'Data';

