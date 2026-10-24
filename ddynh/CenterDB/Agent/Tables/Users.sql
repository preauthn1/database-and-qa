CREATE TABLE [Agent].[Users] (
    [AgentID]       INT          IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (32) NOT NULL,
    [WXNo]          VARCHAR (20) NOT NULL,
    [QQ]            VARCHAR (20) NOT NULL,
    [UserID]        INT          NOT NULL,
    [GroupName]     VARCHAR (32) NOT NULL,
    [IsShow]        BIT          NOT NULL,
    [LoginName]     VARCHAR (32) NOT NULL,
    [AdminSysID]    INT          NOT NULL,
    [LastLoginIP]   VARCHAR (15) NOT NULL,
    [LastLoginTime] DATETIME     NOT NULL,
    [PlatformID]    INT          CONSTRAINT [DF_Users_PlatformID] DEFAULT ((1)) NOT NULL,
    [CreateTime]    DATETIME     NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理基本信息', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'微信号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'WXNo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏用户ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QQ号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'QQ';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台账号登录名称', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LoginName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登陆时间', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LastLoginTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录IP地址', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'LastLoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否显示', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'IsShow';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分组名称', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'AgentID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台账号ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'AdminSysID';

