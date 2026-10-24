CREATE TABLE [Admin].[Role] (
    [RoleID]            INT            IDENTITY (1, 1) NOT NULL,
    [RoleName]          VARCHAR (200)  NOT NULL,
    [Memo]              NVARCHAR (100) NULL,
    [OrgID]             INT            CONSTRAINT [DF__Role__OrgID__4F67C174] DEFAULT ((1)) NOT NULL,
    [IsSystemDefault]   BIT            CONSTRAINT [DF__Role__IsSystemDe__505BE5AD] DEFAULT ((0)) NOT NULL,
    [IsTemplateForCopy] BIT            CONSTRAINT [DF__Role__IsTemplate__515009E6] DEFAULT ((0)) NOT NULL,
    [CreateTime]        DATETIME       CONSTRAINT [DF__Role__CreateTime__60924D76] DEFAULT (getdate()) NOT NULL,
    [ParentTemplateID]  INT            NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([RoleID] ASC)
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Role';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色名称', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'RoleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色编号（主键）', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'RoleID';

