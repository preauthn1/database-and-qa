CREATE TABLE [Admin].[Users] (
    [UserID]             INT          IDENTITY (1, 1) NOT NULL,
    [LoginName]          VARCHAR (32) NOT NULL,
    [Password]           VARCHAR (32) NOT NULL,
    [Status]             TINYINT      NOT NULL,
    [Phone]              VARCHAR (15) NULL,
    [PhoneCode]          VARCHAR (15) NULL,
    [PhoneCodeTime]      DATETIME     NULL,
    [CreateTime]         DATETIME     NOT NULL,
    [LastLogonTime]      DATETIME     NOT NULL,
    [LastLogonIPAddress] VARCHAR (15) NOT NULL,
    [UserType]           TINYINT      CONSTRAINT [DF_Users_UserType] DEFAULT ((0)) NOT NULL,
    [Displayname]        VARCHAR (20) CONSTRAINT [DF_Users_Displayname] DEFAULT ('') NOT NULL,
    [TGChatid]           INT          CONSTRAINT [DF_Users_TGChatid] DEFAULT ((0)) NOT NULL,
    [SecretKey]          INT          CONSTRAINT [DF_Users_SecretKey] DEFAULT ((0)) NOT NULL,
    [OrgID]              INT          DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC)
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_Users_LoginName]
    ON [Admin].[Users]([LoginName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户信息', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号（主键）', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'状态', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机验证码获取时间', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'PhoneCodeTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机验证码', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'PhoneCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录密码', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'Password';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录名', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LoginName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录时间', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LastLogonTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录IP地址', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LastLogonIPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'添加时间', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'CreateTime';

