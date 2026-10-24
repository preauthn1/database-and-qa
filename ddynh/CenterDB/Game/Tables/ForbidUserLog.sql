CREATE TABLE [Game].[ForbidUserLog] (
    [LogID]      INT           IDENTITY (1, 1) NOT NULL,
    [UserID]     INT           NOT NULL,
    [ForbidType] TINYINT       NOT NULL,
    [CashAmount] BIGINT        NOT NULL,
    [BankAmount] BIGINT        NOT NULL,
    [Memo]       VARCHAR (128) NOT NULL,
    [IPAddress]  VARCHAR (15)  NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_ForbidUserLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_ForbidUserLog_CreateTime]
    ON [Game].[ForbidUserLog]([CreateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ForbidUserLog_UserID]
    ON [Game].[ForbidUserLog]([UserID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'封号记录', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备注', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'封号类型，0 = 封號、1 = 解封', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'ForbidType';




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'现金数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'CashAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUserLog', @level2type = N'COLUMN', @level2name = N'BankAmount';

