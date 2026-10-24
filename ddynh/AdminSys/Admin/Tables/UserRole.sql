CREATE TABLE [Admin].[UserRole] (
    [Id]     INT IDENTITY (1, 1) NOT NULL,
    [UserID] INT NOT NULL,
    [RoleID] INT NOT NULL,
    CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([UserID] ASC, [RoleID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户角色关联', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRole';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'RoleID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'Id';

