CREATE TABLE [Area].[PlatformAdminUser] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [AdminID]    INT NOT NULL,
    [PlatformID] INT NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台管理用户', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'PlatformAdminUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'PlatformAdminUser', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'PlatformAdminUser', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台管理员ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'PlatformAdminUser', @level2type = N'COLUMN', @level2name = N'AdminID';

