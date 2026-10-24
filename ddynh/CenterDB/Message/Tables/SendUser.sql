CREATE TABLE [Message].[SendUser] (
    [UserID] INT NOT NULL,
    [MsgID]  INT NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息发送用户', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'SendUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'SendUser', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息编号', @level0type = N'SCHEMA', @level0name = N'Message', @level1type = N'TABLE', @level1name = N'SendUser', @level2type = N'COLUMN', @level2name = N'MsgID';

