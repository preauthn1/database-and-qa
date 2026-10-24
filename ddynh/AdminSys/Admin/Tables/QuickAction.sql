CREATE TABLE [Admin].[QuickAction] (
    [Id]     INT            IDENTITY (1, 1) NOT NULL,
    [UserID] INT            NOT NULL,
    [Name]   VARCHAR (64)   NOT NULL,
    [Url]    VARCHAR (1024) NOT NULL,
    [Sort]   INT            NOT NULL,
    CONSTRAINT [PK_QuickAction] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_QuickAction_UserID]
    ON [Admin].[QuickAction]([UserID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'快捷操作', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'页面地址', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction', @level2type = N'COLUMN', @level2name = N'Url';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号（主键）', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'QuickAction', @level2type = N'COLUMN', @level2name = N'Id';

