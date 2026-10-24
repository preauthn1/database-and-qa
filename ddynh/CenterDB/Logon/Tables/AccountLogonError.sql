CREATE TABLE [Logon].[AccountLogonError] (
    [LoginName]  VARCHAR (32) NOT NULL,
    [ErrorTimes] INT          NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'账号登录错误记录', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'AccountLogonError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录名', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'AccountLogonError', @level2type = N'COLUMN', @level2name = N'LoginName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'错误次数', @level0type = N'SCHEMA', @level0name = N'Logon', @level1type = N'TABLE', @level1name = N'AccountLogonError', @level2type = N'COLUMN', @level2name = N'ErrorTimes';

