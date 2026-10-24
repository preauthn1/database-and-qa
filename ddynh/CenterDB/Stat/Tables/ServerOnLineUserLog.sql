CREATE TABLE [Stat].[ServerOnLineUserLog] (
    [Id]           INT      IDENTITY (1, 1) NOT NULL,
    [ServerID]     INT      NOT NULL,
    [TotalCount]   INT      NOT NULL,
    [PCCount]      INT      NOT NULL,
    [IOSCount]     INT      NOT NULL,
    [AndroidCount] INT      NOT NULL,
    [PlatformID]   INT      CONSTRAINT [DF_ServerOnLineUserLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [StatTime]     DATETIME NOT NULL,
    CONSTRAINT [PK_ServerOnLineUserLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_ServerOnLineUserLog_ServerID_StatTime]
    ON [Stat].[ServerOnLineUserLog]([ServerID] ASC, [StatTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ServerOnLineUserLog_StatTime_INCLUDE]
    ON [Stat].[ServerOnLineUserLog]([StatTime] ASC)
    INCLUDE([ServerID], [TotalCount], [PCCount], [IOSCount], [AndroidCount]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器在线人数记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PCCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'IOSCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineUserLog', @level2type = N'COLUMN', @level2name = N'AndroidCount';

