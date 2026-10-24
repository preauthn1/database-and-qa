CREATE TABLE [Stat].[ConvertLog] (
    [Id]            INT      IDENTITY (1, 1) NOT NULL,
    [Amount]        BIGINT   NOT NULL,
    [TaxAmount]     BIGINT   CONSTRAINT [DF_ConvertLog_TaxAmount] DEFAULT ((0)) NOT NULL,
    [RealTaxAmount] BIGINT   CONSTRAINT [DF_ConvertLog_RealAmount] DEFAULT ((0)) NOT NULL,
    [StatTime]      DATETIME NOT NULL,
    CONSTRAINT [PK_ConvertLog_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IUX_ConvertLog_StatTime]
    ON [Stat].[ConvertLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换记录统计', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'真实税收金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'RealTaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Amount';

