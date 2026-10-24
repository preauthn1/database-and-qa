CREATE TABLE [Warning].[WarningLog] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [TypeID]     INT           NOT NULL,
    [Memo]       VARCHAR (128) NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_WarningLog] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);




GO
CREATE NONCLUSTERED INDEX [IX_WarningLog_CreateTime]
    ON [Warning].[WarningLog]([CreateTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警类型编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'TypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警时间', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'CreateTime';

