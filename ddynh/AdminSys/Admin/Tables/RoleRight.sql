CREATE TABLE [Admin].[RoleRight] (
    [Id]      INT IDENTITY (637, 1) NOT NULL,
    [RoleID]  INT NOT NULL,
    [RightID] INT NOT NULL,
    CONSTRAINT [PK_RoleRight] PRIMARY KEY CLUSTERED ([RoleID] ASC, [RightID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Table', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'RoleRight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'RoleRight', @level2type = N'COLUMN', @level2name = N'RoleID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'RoleRight', @level2type = N'COLUMN', @level2name = N'RightID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'RoleRight', @level2type = N'COLUMN', @level2name = N'Id';

