CREATE TABLE [Warning].[WarningType] (
    [TypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [TypeName] VARCHAR (32)   NOT NULL,
    [Status]   TINYINT        NOT NULL,
    [Setting]  VARCHAR (8000) NULL,
    CONSTRAINT [PK_WarningType] PRIMARY KEY CLUSTERED ([TypeID] ASC) WITH (FILLFACTOR = 80)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_WarningType_TypeName]
    ON [Warning].[WarningType]([TypeName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警类型', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningType', @level2type = N'COLUMN', @level2name = N'TypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningType', @level2type = N'COLUMN', @level2name = N'TypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警类型状态', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningType', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警配置 XML格式数据', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningType', @level2type = N'COLUMN', @level2name = N'Setting';

