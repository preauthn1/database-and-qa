CREATE TABLE [Pay].[PayNotify] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [UserID]     INT      NOT NULL,
    [PayAmount]  BIGINT   NOT NULL,
    [CreateTime] DATETIME NOT NULL,
    CONSTRAINT [PK_PayNotify_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_PayNotify_UserID]
    ON [Pay].[PayNotify]([UserID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值到账通知', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayNotify';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户ID', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayNotify', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值金币数', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayNotify', @level2type = N'COLUMN', @level2name = N'PayAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录ID', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayNotify', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayNotify', @level2type = N'COLUMN', @level2name = N'CreateTime';

