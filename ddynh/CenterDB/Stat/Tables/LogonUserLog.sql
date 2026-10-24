CREATE TABLE [Stat].[LogonUserLog] (
    [Id]                INT      IDENTITY (1, 1) NOT NULL,
    [TotalLogonCount]   INT      NOT NULL,
    [PCLogonCount]      INT      NOT NULL,
    [IOSLogonCount]     INT      NOT NULL,
    [AndroidLogonCount] INT      NOT NULL,
    [PlatformID]        INT      CONSTRAINT [DF_LogonUserLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [StatTime]          DATETIME NOT NULL,
    CONSTRAINT [PK_LogonUserLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_LogonUserLog_StatTime]
    ON [Stat].[LogonUserLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录用户统计', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总登录人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'TotalLogonCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC登录人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'PCLogonCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS登录人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'IOSLogonCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android登录人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'LogonUserLog', @level2type = N'COLUMN', @level2name = N'AndroidLogonCount';

