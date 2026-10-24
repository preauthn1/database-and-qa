CREATE TABLE [Money].[BankLog] (
    [LogID]         INT           IDENTITY (1, 1) NOT NULL,
    [UserID]        INT           NOT NULL,
    [SourceTypeID]  INT           NOT NULL,
    [CashAmount]    BIGINT        NOT NULL,
    [CurrentAmount] BIGINT        NOT NULL,
    [UpdateAmount]  BIGINT        NOT NULL,
    [IPAddress]     VARCHAR (15)  NOT NULL,
    [Memo]          VARCHAR (128) NOT NULL,
    [CreateTime]    DATETIME      NOT NULL,
    [AreaID]        INT           NULL,
    [PlatformID]    INT           NULL
) ON [S_Data] ([CreateTime]);




GO
CREATE CLUSTERED INDEX [ICX_BankLog_CreateTime]
    ON [Money].[BankLog]([CreateTime] ASC) WITH (FILLFACTOR = 80)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_BankLog_SourceTypeID]
    ON [Money].[BankLog]([SourceTypeID] ASC) WITH (FILLFACTOR = 80)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_BankLog_UserID]
    ON [Money].[BankLog]([UserID] ASC) WITH (FILLFACTOR = 80)
    ON [S_Data] ([CreateTime]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行记录', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户ID', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'更新的金额', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'UpdateAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流通类型', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'SourceTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'当前金额', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'CurrentAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'当前现金数', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'BankLog', @level2type = N'COLUMN', @level2name = N'CashAmount';

