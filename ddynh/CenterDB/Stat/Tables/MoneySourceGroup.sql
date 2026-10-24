CREATE TABLE [Stat].[MoneySourceGroup] (
    [Id]        INT          NOT NULL,
    [GroupName] VARCHAR (32) NOT NULL,
    [Sort]      INT          NOT NULL,
    CONSTRAINT [PK_MoneySourceGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_MoneySourceGroup_GroupName]
    ON [Stat].[MoneySourceGroup]([GroupName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'现金流通类型分组', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceGroup', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分组编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceGroup', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分组名称', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceGroup', @level2type = N'COLUMN', @level2name = N'GroupName';

