CREATE TABLE [Game].[TGW_BonusGameRecord] (
    [ID]       BIGINT IDENTITY (1, 1) NOT NULL,
    [UserID]   INT    CONSTRAINT [DF_TGW_BonusGameRecord_UserID] DEFAULT ((0)) NOT NULL,
    [TurnID]   INT    CONSTRAINT [DF_TGW_BonusGameRecord_TurnID] DEFAULT ((0)) NOT NULL,
    [Location] INT    CONSTRAINT [DF_TGW_BonusGameRecord_Location] DEFAULT ((0)) NOT NULL,
    [Money]    BIGINT CONSTRAINT [DF_TGW_BonusGameRecord_Money] DEFAULT ((0)) NOT NULL,
    [BonusID]  INT    CONSTRAINT [DF_TGW_BonusGameRecord_BonusID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TGW_BonusGameRecord] PRIMARY KEY NONCLUSTERED ([ID] ASC),
    CONSTRAINT [IX_TGW_BonusGameRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [TurnID] ASC)
);

