CREATE TABLE [Stat].[GameOnLineRobotLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [GameID]     INT      NOT NULL,
    [TotalCount] INT      NOT NULL,
    [StatTime]   DATETIME NULL,
    CONSTRAINT [PK_RobotOnLineLog_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_RobotOnLineLog_StatTime]
    ON [Stat].[GameOnLineRobotLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人游戏在线人数记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineRobotLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'GameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'GameID';

