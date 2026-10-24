CREATE TABLE [Agent].[TransferType] (
    [SourceID]   INT          NOT NULL,
    [SourceName] VARCHAR (32) NOT NULL,
    CONSTRAINT [PK_TransferType_SourceID] PRIMARY KEY CLUSTERED ([SourceID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'转账类型配置表', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'TransferType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型名称', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'TransferType', @level2type = N'COLUMN', @level2name = N'SourceName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型编号', @level0type = N'SCHEMA', @level0name = N'Agent', @level1type = N'TABLE', @level1name = N'TransferType', @level2type = N'COLUMN', @level2name = N'SourceID';

