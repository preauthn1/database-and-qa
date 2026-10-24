CREATE TABLE [Users].[QuestionLog] (
    [Id]           INT             IDENTITY (1, 1) NOT NULL,
    [PlatformID]   INT             CONSTRAINT [DF_QuestionLog_PlatformID] DEFAULT ((1)) NOT NULL,
    [UserID]       INT             NOT NULL,
    [Question]     VARCHAR (512)   NOT NULL,
    [QuestionType] TINYINT         CONSTRAINT [DF_QuestionLog_QuestionType] DEFAULT ((0)) NOT NULL,
    [Status]       TINYINT         NOT NULL,
    [IPAddress]    VARCHAR (15)    NOT NULL,
    [HandleTime]   DATETIME        NULL,
    [HandlePerson] VARCHAR (32)    NULL,
    [ReplyContent] NVARCHAR (2048) NULL,
    [UserEmail]    VARCHAR (50)    NULL,
    [CreateTime]   DATETIME        NOT NULL,
    [UploadImage]  VARCHAR (50)    CONSTRAINT [DF_QuestionLog_UploadImage] DEFAULT ('') NULL,
    [Operator]     INT             NULL
) ON [S_Data] ([CreateTime]);




GO
CREATE CLUSTERED INDEX [IX_QuestionLog_CreateTime]
    ON [Users].[QuestionLog]([CreateTime] ASC)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_QuestionLog_Id]
    ON [Users].[QuestionLog]([Id] ASC)
    INCLUDE([Status], [CreateTime], [UserID], [HandlePerson])
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_QuestionLog_UserID]
    ON [Users].[QuestionLog]([UserID] ASC)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_QuestionLog_QT_STS_HP_INCLUDE]
    ON [Users].[QuestionLog]([QuestionType] ASC, [Status] ASC, [CreateTime] ASC, [HandlePerson] ASC)
    INCLUDE([Id], [PlatformID], [UserID], [Question], [IPAddress], [HandleTime], [ReplyContent], [UploadImage])
    ON [S_Data] ([CreateTime]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户问题记录', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'状态', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'回复内容', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'ReplyContent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题内容', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'Question';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'处理时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'HandleTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'处理人', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'HandlePerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'QuestionLog', @level2type = N'COLUMN', @level2name = N'CreateTime';

