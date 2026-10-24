CREATE TABLE [Customer].[ReplyContent] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Title]       VARCHAR (64)   NOT NULL,
    [Content]     NVARCHAR (256) NOT NULL,
    [ReplyTypeID] INT            NOT NULL,
    [Sort]        INT            NOT NULL,
    CONSTRAINT [PK_ReplyContent] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'快捷回复内容表', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'标题', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent', @level2type = N'COLUMN', @level2name = N'Title';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'快捷回复类型编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent', @level2type = N'COLUMN', @level2name = N'ReplyTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'内容', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'ReplyContent', @level2type = N'COLUMN', @level2name = N'Content';

