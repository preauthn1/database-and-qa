CREATE TABLE [Admin].[UserRight] (
    [Id]      INT IDENTITY (186, 1) NOT NULL,
    [UserID]  INT NOT NULL,
    [RightID] INT NOT NULL,
    CONSTRAINT [PK_UserRight] PRIMARY KEY CLUSTERED ([UserID] ASC, [RightID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户权限关联', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRight', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'权限编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRight', @level2type = N'COLUMN', @level2name = N'RightID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'UserRight', @level2type = N'COLUMN', @level2name = N'Id';

