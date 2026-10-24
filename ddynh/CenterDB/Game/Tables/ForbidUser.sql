CREATE TABLE [Game].[ForbidUser] (
    [UserID]     INT           NOT NULL,
    [CashAmount] BIGINT        NOT NULL,
    [BankAmount] BIGINT        NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    [Memo]       VARCHAR (128) NOT NULL,
    CONSTRAINT [PK_ForbidUser] PRIMARY KEY CLUSTERED ([UserID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'封号用户', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'现金数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser', @level2type = N'COLUMN', @level2name = N'CashAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidUser', @level2type = N'COLUMN', @level2name = N'BankAmount';

