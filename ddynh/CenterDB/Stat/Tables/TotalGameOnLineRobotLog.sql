CREATE TABLE [Stat].[TotalGameOnLineRobotLog] (
    [Id]         INT      IDENTITY (1, 1) NOT NULL,
    [TotalCount] INT      NOT NULL,
    [StatTime]   DATETIME NOT NULL,
    CONSTRAINT [PK_TotalGameOnLineRobotLog_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_TotalGameOnLineRobotLog_StatTime]
    ON [Stat].[TotalGameOnLineRobotLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人总在线人数统计表', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineRobotLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineRobotLog', @level2type = N'COLUMN', @level2name = N'Id';

