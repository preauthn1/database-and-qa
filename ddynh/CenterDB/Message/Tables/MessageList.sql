CREATE TABLE [Message].[MessageList] (
    [MsgID]      INT            IDENTITY (1, 1) NOT NULL,
    [Title]      VARCHAR (128)  NOT NULL,
    [MsgContent] VARCHAR (1024) NOT NULL,
    [Type]       TINYINT        NOT NULL,
    [FromUserID] INT            NULL,
    [Sort]       INT            NOT NULL,
    [CreateTime] DATETIME       NOT NULL,
    [MsgSeq]     BIGINT         NULL,
    [SubType]    INT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_MessageList] PRIMARY KEY NONCLUSTERED ([MsgID] ASC) ON [PRIMARY]
) ON [S_Data] ([CreateTime]);






GO
CREATE NONCLUSTERED INDEX [IX_MessageList_CreateTime]
    ON [Message].[MessageList]([CreateTime] ASC)
    ON [S_Data] ([CreateTime]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'短消息', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息类型', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息标题', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'Title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'MsgID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息内容', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'MsgContent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'发送者用户编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'FromUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'MessageList', @level2type = N'COLUMN', @level2name = N'CreateTime';

