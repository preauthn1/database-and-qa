CREATE TABLE [Message].[ReceiveUser] (
    [Id]       INT      IDENTITY (1, 1) NOT NULL,
    [MsgID]    INT      NOT NULL,
    [UserID]   INT      NOT NULL,
    [Status]   TINYINT  NOT NULL,
    [ReadTime] DATETIME NULL,
    [MsgSeq]   BIGINT   NULL,
    CONSTRAINT [PK_ReceiveUser] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_ReceiveUser_MsgID_UserID]
    ON [Message].[ReceiveUser]([MsgID] ASC, [UserID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息接收用户', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息状态', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'阅读时间', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser', @level2type = N'COLUMN', @level2name = N'ReadTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser', @level2type = N'COLUMN', @level2name = N'MsgID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'ReceiveUser', @level2type = N'COLUMN', @level2name = N'Id';

