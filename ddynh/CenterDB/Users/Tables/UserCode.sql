CREATE TABLE [Users].[UserCode] (
    [Tel]            VARCHAR (11) NOT NULL,
    [VCode]          VARCHAR (32) NOT NULL,
    [CodeType]       TINYINT      NOT NULL,
    [CreateCodeTime] DATETIME     NOT NULL,
    CONSTRAINT [PK_UserCode_UserID_CodeType] PRIMARY KEY CLUSTERED ([Tel] ASC, [CodeType] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户验证码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'验证码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserCode', @level2type = N'COLUMN', @level2name = N'VCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserCode', @level2type = N'COLUMN', @level2name = N'Tel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'验证码创建时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserCode', @level2type = N'COLUMN', @level2name = N'CreateCodeTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'验证码类型 1注册,2找回密码 3找回银行密码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserCode', @level2type = N'COLUMN', @level2name = N'CodeType';

