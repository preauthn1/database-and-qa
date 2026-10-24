CREATE TABLE [Customer].[QuestionList] (
    [Id]                     INT           IDENTITY (1, 1) NOT NULL,
    [QsTypeId]               INT           NOT NULL,
    [Title]                  VARCHAR (128) NOT NULL,
    [ClientType]             TINYINT       NOT NULL,
    [Origin]                 TINYINT       NOT NULL,
    [ChildTypeFiledsContent] VARCHAR (MAX) NULL,
    [ContactName]            VARCHAR (20)  NULL,
    [ContactPhone]           VARCHAR (128) NULL,
    [HandleStatus]           TINYINT       NOT NULL,
    [CreateUserName]         VARCHAR (20)  NOT NULL,
    [CreateTime]             DATETIME      NOT NULL,
    [Memo]                   VARCHAR (MAX) NULL,
    [SiteID]                 INT           NOT NULL,
    [UserID]                 INT           NULL,
    CONSTRAINT [PK_QuestionList] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户问题', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题标题', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'Title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分站编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'SiteID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题类型编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'QsTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'来源', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'Origin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题编号（主键）', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'处理状态', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'HandleStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建人名称', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'CreateUserName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'联系人电话', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'ContactPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'联系人名称', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'ContactName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户端类型', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'ClientType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'详情内容', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionList', @level2type = N'COLUMN', @level2name = N'ChildTypeFiledsContent';

