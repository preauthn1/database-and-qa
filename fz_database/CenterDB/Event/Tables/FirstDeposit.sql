CREATE TABLE [Event].[FirstDeposit] (
    [ID]           INT      IDENTITY (1, 1) NOT NULL,
    [PlatformID]   INT      NOT NULL,
    [AreaID]       INT      NOT NULL,
    [StartTime]    DATETIME CONSTRAINT [DF_FirstDeposit_StartTime] DEFAULT (getdate()) NOT NULL,
    [EndTime]      DATETIME NULL,
    [DepositLimit] BIGINT   CONSTRAINT [DF_FirstDeposit_DepositLimit] DEFAULT ((0)) NOT NULL,
    [WinAmount]    BIGINT   CONSTRAINT [DF_FirstDeposit_WinAmount] DEFAULT ((0)) NOT NULL,
    [ReturnAmount] BIGINT   CONSTRAINT [DF_FirstDeposit_ReturnAmount] DEFAULT ((0)) NOT NULL,
    [Status]       TINYINT  CONSTRAINT [DF_FirstDeposit_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_FirstDeposit] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [IX_FirstDeposit_1] UNIQUE NONCLUSTERED ([PlatformID] ASC, [AreaID] ASC, [Status] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'單筆充值金額條件(單位: 分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDeposit', @level2type = N'COLUMN', @level2name = N'DepositLimit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'累计赢钱额度(單位:分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDeposit', @level2type = N'COLUMN', @level2name = N'WinAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'返利金額(單位: 分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDeposit', @level2type = N'COLUMN', @level2name = N'ReturnAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'活動狀態(0: 關, 1:開)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FirstDeposit', @level2type = N'COLUMN', @level2name = N'Status';

