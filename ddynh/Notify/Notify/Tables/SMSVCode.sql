CREATE TABLE [Notify].[SMSVCode] (
    [CodeID]       INT            IDENTITY (1, 1) NOT NULL,
    [Tel]          VARCHAR (15)   NOT NULL,
    [VCode]        VARCHAR (32)   NOT NULL,
    [Status]       TINYINT        NOT NULL,
    [CreateTime]   DATETIME       NOT NULL,
    [LastSendTime] DATETIME       NOT NULL,
    [IPAddress]    VARCHAR (40)   NULL,
    [CodeType]     TINYINT        DEFAULT ((0)) NULL,
    [UserID]       INT            NULL,
    [ExpireTime]   DATETIME       NULL,
    [UpdateTime]   DATETIME       NULL,
    [SendResult]   NVARCHAR (512) NULL,
    [Vender]       VARCHAR (20)   NULL,
    CONSTRAINT [PK_SMSVCode] PRIMARY KEY CLUSTERED ([CodeID] ASC, [CreateTime] ASC) ON [S_Day] ([CreateTime])
) ON [S_Day] ([CreateTime]);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'短信验证码', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'验证码', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'VCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机号', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'Tel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'状态', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后发送时间', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'LastSendTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'添加时间', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Notify', @level1type = N'TABLE', @level1name = N'SMSVCode', @level2type = N'COLUMN', @level2name = N'CodeID';

