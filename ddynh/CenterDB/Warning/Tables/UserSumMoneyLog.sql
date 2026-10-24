CREATE TABLE [Warning].[UserSumMoneyLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [UserID]     INT      NOT NULL,
    [Amount]     BIGINT   NOT NULL,
    [CreateTime] DATETIME NOT NULL,
    CONSTRAINT [PK_UserSumMoneyLog] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);




GO
CREATE NONCLUSTERED INDEX [IX_UserSumMoneyLog_CreateTime]
    ON [Warning].[UserSumMoneyLog]([CreateTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户总金额报警记录', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserSumMoneyLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserSumMoneyLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserSumMoneyLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警时间', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserSumMoneyLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserSumMoneyLog', @level2type = N'COLUMN', @level2name = N'Amount';

