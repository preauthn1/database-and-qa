CREATE TABLE [Game].[ForbidChatUser] (
    [UserID]     INT           NOT NULL,
    [Memo]       VARCHAR (128) NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_ForbidChatUser] PRIMARY KEY CLUSTERED ([UserID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'禁言用户', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidChatUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidChatUser', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidChatUser', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidChatUser', @level2type = N'COLUMN', @level2name = N'CreateTime';

