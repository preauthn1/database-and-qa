CREATE TABLE [Users].[UserInfoChangeLog] (
    [LogID]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]     INT            NOT NULL,
    [ChangeType] TINYINT        NOT NULL,
    [OldData]    VARCHAR (1024) NOT NULL,
    [NewData]    VARCHAR (1024) NOT NULL,
    [IPAddress]  VARCHAR (15)   NOT NULL,
    [Memo]       VARCHAR (128)  NOT NULL,
    [WriteTime]  DATETIME       NOT NULL,
    CONSTRAINT [PK_UserInfoChangeLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_UserInfoChangeLog_UserID_WriteTime]
    ON [Users].[UserInfoChangeLog]([UserID] ASC, [WriteTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户信息变更记录', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'WriteTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'修改前的数据', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'OldData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'修改后的数据', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'NewData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号（主键）', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户信息变化类型', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfoChangeLog', @level2type = N'COLUMN', @level2name = N'ChangeType';

