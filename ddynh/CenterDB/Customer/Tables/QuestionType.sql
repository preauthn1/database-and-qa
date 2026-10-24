CREATE TABLE [Customer].[QuestionType] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [TypeName]        VARCHAR (128) NOT NULL,
    [TypeSort]        VARCHAR (10)  CONSTRAINT [DF_QuestionType_TypeSort] DEFAULT ('') NOT NULL,
    [ChildTypeFileds] VARCHAR (MAX) CONSTRAINT [DF_QuestionType_ChildTypeFileds] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_QuestionType] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户反映问题类型', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'问题类型名称', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionType', @level2type = N'COLUMN', @level2name = N'TypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型编号（主键）', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionType', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'子类型（键值对）', @level0type = N'SCHEMA', @level0name = N'Customer', @level1type = N'TABLE', @level1name = N'QuestionType', @level2type = N'COLUMN', @level2name = N'ChildTypeFileds';

