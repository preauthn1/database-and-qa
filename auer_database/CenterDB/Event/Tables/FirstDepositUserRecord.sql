CREATE TABLE [Event].[FirstDepositUserRecord] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [UserID]        INT      NOT NULL,
    [EventID]       INT      CONSTRAINT [DF_FirstDepositUserRecord_EventID] DEFAULT ((0)) NOT NULL,
    [JoinTime]      DATETIME CONSTRAINT [DF_FirstDepositUserRecord_JoinTime] DEFAULT ((0)) NOT NULL,
    [DepositAmount] BIGINT   CONSTRAINT [DF_FirstDepositUserRecord_DepositAmount] DEFAULT ((0)) NOT NULL,
    [WinAmount]     BIGINT   CONSTRAINT [DF_FirstDepositUserRecord_WinAmount] DEFAULT ((0)) NOT NULL,
    [Flag]          TINYINT  CONSTRAINT [DF_FirstDepositUserRecord_Flag] DEFAULT ((0)) NULL,
    [CollectTime]   DATETIME NULL,
    [CollectAmount] BIGINT   NULL,
    CONSTRAINT [PK_FirstDepositUserRecord] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_FirstDepositUserRecord] UNIQUE NONCLUSTERED ([UserID] ASC, [EventID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'對應活動ID', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDepositUserRecord', @level2type = N'COLUMN', @level2name = N'EventID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'加入時間', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDepositUserRecord', @level2type = N'COLUMN', @level2name = N'JoinTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'當次單筆充值金額', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDepositUserRecord', @level2type = N'COLUMN', @level2name = N'DepositAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'累計贏錢額度(單位:分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDepositUserRecord', @level2type = N'COLUMN', @level2name = N'WinAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'領取時間', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDepositUserRecord', @level2type = N'COLUMN', @level2name = N'CollectTime';

