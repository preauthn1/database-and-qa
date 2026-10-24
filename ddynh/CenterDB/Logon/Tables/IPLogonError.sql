CREATE TABLE [Logon].[IPLogonError] (
    [IPAddress]  VARCHAR (15) NOT NULL,
    [ErrorTimes] INT          NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址登录错误记录', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'IPLogonError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'IPLogonError', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'错误次数', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'IPLogonError', @level2type = N'COLUMN', @level2name = N'ErrorTimes';

