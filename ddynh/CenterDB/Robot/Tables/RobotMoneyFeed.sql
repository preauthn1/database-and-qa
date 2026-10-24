CREATE TABLE [Robot].[RobotMoneyFeed] (
    [Id]     INT    IDENTITY (1, 1) NOT NULL,
    [UserID] INT    NOT NULL,
    [Amount] BIGINT NOT NULL,
    CONSTRAINT [PK_RobotMoneyFeed] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人自动补钱名单', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotMoneyFeed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人用户编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotMoneyFeed', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotMoneyFeed', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'补钱金額', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotMoneyFeed', @level2type = N'COLUMN', @level2name = N'Amount';

