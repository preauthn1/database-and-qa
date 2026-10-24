CREATE TABLE [Stat].[GameOnLineUserLog] (
    [Id]           INT      IDENTITY (1, 1) NOT NULL,
    [GameID]       INT      NOT NULL,
    [TotalCount]   INT      NOT NULL,
    [PCCount]      INT      NOT NULL,
    [IOSCount]     INT      NOT NULL,
    [AndroidCount] INT      NOT NULL,
    [PlatformID]   INT      CONSTRAINT [DF_GameOnLineUserLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [StatTime]     DATETIME NOT NULL,
    CONSTRAINT [PK_GameOnLineUserLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_GameOnLineUserLog_GameID_StatTime]
    ON [Stat].[GameOnLineUserLog]([GameID] ASC, [StatTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_GameOnLineUserLog_StatTime]
    ON [Stat].[GameOnLineUserLog]([StatTime] ASC)
    INCLUDE([PCCount], [IOSCount], [AndroidCount]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'PCCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'IOSCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineUserLog', @level2type = N'COLUMN', @level2name = N'AndroidCount';

