CREATE TABLE [PerLog].[DetailLogDel] (
    [Id]            BIGINT   IDENTITY (1, 1) NOT NULL,
    [LogID]         BIGINT   NOT NULL,
    [ServerID]      INT      NOT NULL,
    [UserID]        INT      NOT NULL,
    [CurrentAmount] BIGINT   NOT NULL,
    [UpdateAmount]  BIGINT   NOT NULL,
    [GameTime]      DATETIME NOT NULL,
    [GameID]        INT      NULL,
    [days]          INT      NULL,
    [TradeID]       BIGINT   DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DetailLogDel] PRIMARY KEY CLUSTERED ([GameTime] ASC, [Id] ASC) ON [S_Day] ([GameTime])
) ON [S_Day] ([GameTime]);






GO



GO



GO



GO



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'已删除的每局游戏记录详细', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'更新金币', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'UpdateAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'牌局标识', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录ID', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏时间', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'GameTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'当前金币', @level0type = N'SCHEMA', @level0name = N'PerLog', @level1type = N'TABLE', @level1name = N'DetailLogDel', @level2type = N'COLUMN', @level2name = N'CurrentAmount';


GO
CREATE NONCLUSTERED INDEX [IX_DetailLogDel]
    ON [PerLog].[DetailLogDel]([LogID] ASC, [ServerID] ASC, [UserID] ASC, [TradeID] ASC)
    ON [S_Day] ([GameTime]);

