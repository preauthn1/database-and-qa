CREATE TABLE [Logon].[HDLogonError] (
    [HDType]     TINYINT      NOT NULL,
    [HDCode]     VARCHAR (64) NOT NULL,
    [ErrorTimes] INT          NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件登录错误记录', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'HDLogonError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'HDLogonError', @level2type = N'COLUMN', @level2name = N'HDType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件唯一编码', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'HDLogonError', @level2type = N'COLUMN', @level2name = N'HDCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'错误次数', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'HDLogonError', @level2type = N'COLUMN', @level2name = N'ErrorTimes';

