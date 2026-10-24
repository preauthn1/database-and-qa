CREATE TABLE [Stat].[SumMoneyLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [CashAmount] BIGINT   NOT NULL,
    [BankAmount] BIGINT   NOT NULL,
    [SumIn]      BIGINT   NOT NULL,
    [SumOut]     BIGINT   NOT NULL,
    [StatTime]   DATETIME NOT NULL,
    CONSTRAINT [PK_SumMoneyLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_SumMoneyLog_StatTime]
    ON [Stat].[SumMoneyLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总金币记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总流出', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'SumOut';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总流入', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'SumIn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'现金金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'CashAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'SumMoneyLog', @level2type = N'COLUMN', @level2name = N'BankAmount';

