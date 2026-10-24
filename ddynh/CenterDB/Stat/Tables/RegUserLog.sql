CREATE TABLE [Stat].[RegUserLog] (
    [Id]              INT      IDENTITY (1, 1) NOT NULL,
    [TotalRegCount]   INT      NOT NULL,
    [IOSRegCount]     INT      NOT NULL,
    [AndroidRegCount] INT      NOT NULL,
    [PCRegCount]      INT      NOT NULL,
    [PlatformID]      INT      CONSTRAINT [DF_RegUserLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [StatTime]        DATETIME NOT NULL,
    [AreaID]          INT      NULL,
    CONSTRAINT [PK_RegUserLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_RegUserLog_StatTime]
    ON [Stat].[RegUserLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'注册用户统计', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总注册人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'TotalRegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC注册人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'PCRegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS注册人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'IOSRegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android注册人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'RegUserLog', @level2type = N'COLUMN', @level2name = N'AndroidRegCount';

