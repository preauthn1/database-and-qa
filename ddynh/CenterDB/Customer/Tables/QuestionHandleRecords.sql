CREATE TABLE [Customer].[QuestionHandleRecords] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [QsId]           INT           NOT NULL,
    [QsHandleStatus] TINYINT       NOT NULL,
    [Memo]           VARCHAR (MAX) NULL,
    [CreateTime]     DATETIME      NOT NULL,
    [CreateUserName] VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_QuestionHandleRecord] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题处理进度表', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题编号', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'QsId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题处理状态', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'QsHandleStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号（主键）', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建人名称', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'CreateUserName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionHandleRecords', @level2type = N'COLUMN', @level2name = N'CreateTime';

