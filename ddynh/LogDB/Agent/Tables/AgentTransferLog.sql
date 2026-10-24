CREATE TABLE [Agent].[AgentTransferLog] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [AgentID]         INT          NOT NULL,
    [SourceID]        INT          NOT NULL,
    [RelationUserID]  INT          NOT NULL,
    [RelationAgentID] INT          NULL,
    [SelfAmount]      BIGINT       NOT NULL,
    [RelationAmount]  BIGINT       NOT NULL,
    [UpdateAmount]    BIGINT       NOT NULL,
    [IPAddress]       VARCHAR (15) NOT NULL,
    [CreateTime]      DATETIME     NOT NULL,
    [PlatformID]      INT          NULL,
    [AreaID]          INT          NULL,
    CONSTRAINT [PK_AgentTransferLog] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_AgentTransferLog_CreateTime]
    ON [Agent].[AgentTransferLog]([CreateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AgentTransferLog_1]
    ON [Agent].[AgentTransferLog]([PlatformID] ASC, [AreaID] ASC, [SourceID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理交易记录', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'更新的金币数量', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'UpdateAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'交易类型ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'SourceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'自己的金币数量', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'SelfAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'关联游戏用户ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'RelationUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'关联游戏用户的金币数量', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'RelationAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'关联代理ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'RelationAgentID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'AgentTransferLog', @level2type = N'COLUMN', @level2name = N'AgentID';

