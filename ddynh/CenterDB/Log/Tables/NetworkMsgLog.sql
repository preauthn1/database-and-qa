CREATE TABLE [Log].[NetworkMsgLog] (
    [Id]       INT IDENTITY (1, 1) NOT NULL,
    [ServerID] INT NOT NULL,
    [MsgID]    INT NOT NULL,
    CONSTRAINT [PK_NetworkMsgLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NetworkMsgLog_ServerID_MsgID]
    ON [Log].[NetworkMsgLog]([ServerID] ASC, [MsgID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'网络消息请求记录表。目前只有即时写分和退房间的地方在使用', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'NetworkMsgLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房间服务器ID', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'NetworkMsgLog', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息ID', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'NetworkMsgLog', @level2type = N'COLUMN', @level2name = N'MsgID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录ID', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'NetworkMsgLog', @level2type = N'COLUMN', @level2name = N'Id';

