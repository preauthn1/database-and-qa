CREATE TABLE [Stat].[KeepLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [PlatformID] INT      CONSTRAINT [DF_KeepLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [RegCount]   INT      NOT NULL,
    [OneDayKeep] INT      NULL,
    [TwoDayKeep] INT      NULL,
    [WeekKeep]   INT      NULL,
    [MonthKeep]  INT      NULL,
    [StatTime]   DATETIME NOT NULL,
    [AreaID]     INT      NULL,
    [Third]      INT      DEFAULT ((0)) NOT NULL,
    [Fourth]     INT      DEFAULT ((0)) NOT NULL,
    [Fifth]      INT      DEFAULT ((0)) NOT NULL,
    [Sixth]      INT      DEFAULT ((0)) NOT NULL,
    [eighth]     INT      DEFAULT ((0)) NOT NULL,
    [ninth]      INT      DEFAULT ((0)) NOT NULL,
    [tenth]      INT      DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_KeepLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_KeepLog_StatTime]
    ON [Stat].[KeepLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'留存率记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'一周后登陆的', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'WeekKeep';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'两天后登陆的', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'TwoDayKeep';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'注册数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'RegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'一天后登陆的', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'OneDayKeep';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'一月后登陆的', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'MonthKeep';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'KeepLog', @level2type = N'COLUMN', @level2name = N'Id';

