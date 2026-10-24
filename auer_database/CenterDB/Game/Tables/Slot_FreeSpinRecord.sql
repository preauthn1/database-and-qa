CREATE TABLE [Game].[Slot_FreeSpinRecord] (
    [ID]            BIGINT  IDENTITY (1, 1) NOT NULL,
    [UserID]        INT     NOT NULL,
    [GameID]        INT     NOT NULL,
    [UserBet]       BIGINT  NOT NULL,
    [FreeSpinGroup] INT     NOT NULL,
    [Times]         INT     NOT NULL,
    [ChooseRate]    INT     NOT NULL,
    [IsCoupon]      TINYINT DEFAULT ((0)) NULL,
    [FlagID]        INT     NULL,
    [OriginID]      INT     CONSTRAINT [DF_Slot_FreeSpinRecord_OriginID] DEFAULT ((0)) NOT NULL,
    [WinTimes]      INT     CONSTRAINT [DF_Slot_FreeSpinRecord_WinTimes] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DFDC_FreeSpinRecord] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_Slot_FreeSpinRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [GameID] ASC, [FlagID] ASC)
);

