CREATE TABLE [Agent].[ReportLog] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [PlatformID] INT           CONSTRAINT [DF_ReportLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [AgentName]  VARCHAR (32)  NOT NULL,
    [Memo]       VARCHAR (MAX) NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_ReportLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'举报代理记录', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备注', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代理名称', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'ReportLog', @level2type = N'COLUMN', @level2name = N'AgentName';

