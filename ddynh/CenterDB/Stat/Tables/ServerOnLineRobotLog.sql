CREATE TABLE [Stat].[ServerOnLineRobotLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [ServerID]   INT      NOT NULL,
    [TotalCount] INT      NOT NULL,
    [StatTime]   DATETIME NOT NULL,
    CONSTRAINT [PK_ServerOnLineRobotLog_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_ServerOnLineRobotLog_StatTime]
    ON [Stat].[ServerOnLineRobotLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器机器人在线人数记录', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineRobotLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'ServerOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'Id';

