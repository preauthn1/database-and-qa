CREATE TABLE [Stat].[MoneySourceLog] (
    [Id]             INT      IDENTITY (1, 1) NOT NULL,
    [SourceID]       INT      NOT NULL,
    [Amount]         BIGINT   NOT NULL,
    [RobotAmount]    BIGINT   CONSTRAINT [DF_MoneySourceLog_RobotAmount] DEFAULT ((0)) NOT NULL,
    [RobotTaxAmount] BIGINT   CONSTRAINT [DF_MoneySourceLog_RobotTaxAmount] DEFAULT ((0)) NOT NULL,
    [TaxAmount]      BIGINT   CONSTRAINT [DF_MoneySourceLog_TaxAmount] DEFAULT ((0)) NOT NULL,
    [StatTime]       DATETIME NOT NULL,
    CONSTRAINT [PK_MoneySourceLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_MoneySourceLog_SourceID_StatTime]
    ON [Stat].[MoneySourceLog]([StatTime] ASC, [SourceID] ASC)
    INCLUDE([Amount], [RobotAmount], [RobotTaxAmount], [TaxAmount]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金币流向统计记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流向类型编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'SourceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人税收', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'RobotTaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'RobotAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceLog', @level2type = N'COLUMN', @level2name = N'Amount';

