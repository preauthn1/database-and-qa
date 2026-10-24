CREATE TABLE [Stat].[BankSourceLog] (
    [Id]       INT      IDENTITY (1, 1) NOT NULL,
    [SourceID] INT      NOT NULL,
    [Amount]   BIGINT   NOT NULL,
    [StatTime] DATETIME NOT NULL,
    CONSTRAINT [PK_BankSourceLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_BankSourceLog_SourceID_StatTime]
    ON [Stat].[BankSourceLog]([SourceID] ASC, [StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行金币流向记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'BankSourceLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'BankSourceLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流向类型编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'BankSourceLog', @level2type = N'COLUMN', @level2name = N'SourceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'BankSourceLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'BankSourceLog', @level2type = N'COLUMN', @level2name = N'Amount';

