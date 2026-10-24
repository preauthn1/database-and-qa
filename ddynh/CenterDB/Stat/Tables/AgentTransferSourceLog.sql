CREATE TABLE [Stat].[AgentTransferSourceLog] (
    [Id]       INT      IDENTITY (1, 1) NOT NULL,
    [AgentID]  INT      NOT NULL,
    [SourceID] INT      NOT NULL,
    [Amount]   BIGINT   NOT NULL,
    [StatTime] DATETIME NOT NULL
);




GO
CREATE NONCLUSTERED INDEX [IDX_AgentTransferSourceLog_StatTime_INCLUDE]
    ON [Stat].[AgentTransferSourceLog]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理交易记录日报表', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'交易类型编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog', @level2type = N'COLUMN', @level2name = N'SourceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金币数量', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog', @level2type = N'COLUMN', @level2name = N'Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AgentTransferSourceLog', @level2type = N'COLUMN', @level2name = N'AgentID';

