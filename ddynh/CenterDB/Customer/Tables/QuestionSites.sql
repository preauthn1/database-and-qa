CREATE TABLE [Customer].[QuestionSites] (
    [Id]       INT          NOT NULL,
    [SiteName] VARCHAR (64) NOT NULL,
    CONSTRAINT [PK_QuestionSites] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分站', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionSites';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分站名称', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionSites', @level2type = N'COLUMN', @level2name = N'SiteName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分站编号（主键）', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionSites', @level2type = N'COLUMN', @level2name = N'Id';

