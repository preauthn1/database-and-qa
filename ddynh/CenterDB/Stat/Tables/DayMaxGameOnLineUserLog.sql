CREATE TABLE [Stat].[DayMaxGameOnLineUserLog] (
    [Id]           INT      IDENTITY (1, 1) NOT NULL,
    [GameID]       INT      NOT NULL,
    [TotalCount]   INT      NOT NULL,
    [PCCount]      INT      NOT NULL,
    [IOSCount]     INT      NOT NULL,
    [AndroidCount] INT      NOT NULL,
    [PlatformID]   INT      CONSTRAINT [DF_DayMaxGameOnLineUserLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [StatTime]     DATETIME NOT NULL,
    CONSTRAINT [PK_DayMaxGameOnLineUserLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_DayMaxGameOnLineUserLog_GameID_StatTime]
    ON [Stat].[DayMaxGameOnLineUserLog]([GameID] ASC, [StatTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_DayMaxGameOnLineUserLog_PID_ST_INCLUDE]
    ON [Stat].[DayMaxGameOnLineUserLog]([PlatformID] ASC, [StatTime] ASC)
    INCLUDE([GameID], [TotalCount]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'每天游戏最高在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PCCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'IOSCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'DayMaxGameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'AndroidCount';

