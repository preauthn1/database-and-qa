CREATE TABLE [Admin].[SystemAdminRightSetting] (
    [Id]      INT IDENTITY (1, 1) NOT NULL,
    [RightID] INT NOT NULL,
    CONSTRAINT [PK_SystemAdminRightSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'若此table設定的資料，代表只有系統管理員可以看到', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'SystemAdminRightSetting';

