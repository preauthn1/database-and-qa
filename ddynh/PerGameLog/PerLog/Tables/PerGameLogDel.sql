CREATE TABLE [PerLog].[PerGameLogDel] (
    [Id]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [ServerID]  INT           NOT NULL,
    [GameData]  VARCHAR (MAX) NULL,
    [TaxAmount] BIGINT        NOT NULL,
    [BeginTime] DATETIME      NOT NULL,
    [EndTime]   DATETIME      NOT NULL,
    [GameID]    INT           NULL,
    [days]      INT           NULL,
    CONSTRAINT [PK_PerGameLogDel] PRIMARY KEY CLUSTERED ([EndTime] ASC, [Id] ASC) ON [S_Day] ([EndTime])
) ON [S_Day] ([EndTime]);






GO



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'已删除的每局游戏记录', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏数据', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'GameData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'结束时间', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'EndTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'开始时间', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'PerGameLogDel', @level2type = N'COLUMN', @level2name = N'BeginTime';

