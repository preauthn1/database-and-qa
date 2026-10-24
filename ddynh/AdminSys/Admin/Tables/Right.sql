CREATE TABLE [Admin].[Right] (
    [RightID]    INT           IDENTITY (368, 1) NOT NULL,
    [RightName]  VARCHAR (32)  NOT NULL,
    [ParentID]   INT           NOT NULL,
    [RightToken] VARCHAR (128) NOT NULL,
    [PageUrl]    VARCHAR (512) NULL,
    [RightType]  TINYINT       NOT NULL,
    [Sort]       INT           NOT NULL,
    [ShowInMenu] BIT           NOT NULL,
    [IconCls]    VARCHAR (32)  NULL,
    CONSTRAINT [PK_Right] PRIMARY KEY CLUSTERED ([RightID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_Right_RightToken]
    ON [Admin].[Right]([RightToken] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否显示菜单', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'ShowInMenu';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限类型', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'RightType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限标识', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'RightToken';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限名称', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'RightName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号（主键）', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'RightID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父权限编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'ParentID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'页面地址', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'PageUrl';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'图标', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Right', @level2type = N'COLUMN', @level2name = N'IconCls';

