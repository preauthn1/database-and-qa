CREATE TABLE [ServerInfo].[HallVersion] (
    [AndroidVersion]  VARCHAR (2048) NOT NULL,
    [IOSVersion]      VARCHAR (2048) NOT NULL,
    [AndroidVersion2] VARCHAR (2048) NOT NULL,
    [IOSVersion2]     VARCHAR (2048) NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'大厅版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'HallVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'HallVersion', @level2type = N'COLUMN', @level2name = N'IOSVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'安卓版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'HallVersion', @level2type = N'COLUMN', @level2name = N'AndroidVersion';

