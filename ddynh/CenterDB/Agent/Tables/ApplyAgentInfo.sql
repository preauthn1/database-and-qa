CREATE TABLE [Agent].[ApplyAgentInfo] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [UserID]     INT           CONSTRAINT [DF_ApplyAgentInfo_UserID] DEFAULT ((0)) NOT NULL,
    [PlatformID] INT           CONSTRAINT [DF_ApplyAgentInfo_PlatformID] DEFAULT ((1)) NOT NULL,
    [Name]       VARCHAR (32)  NOT NULL,
    [Tel]        VARCHAR (20)  NOT NULL,
    [QQ]         VARCHAR (20)  NOT NULL,
    [WXNo]       VARCHAR (20)  NOT NULL,
    [Alipay]     VARCHAR (50)  CONSTRAINT [DF_ApplyAgentInfo_Alipay] DEFAULT ('') NOT NULL,
    [Memo]       VARCHAR (256) NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_ApplyAgentInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_ApplyAgentInfo_CreateTime]
    ON [Agent].[ApplyAgentInfo]([CreateTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理申请记录', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'微信号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'WXNo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'电话', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'Tel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'QQ号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'QQ';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'姓名', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备注', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录ID', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ApplyAgentInfo', @level2type = N'COLUMN', @level2name = N'CreateTime';

