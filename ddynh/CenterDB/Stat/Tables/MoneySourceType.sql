CREATE TABLE [Stat].[MoneySourceType] (
    [SourceID]   INT          NOT NULL,
    [SourceName] VARCHAR (32) NOT NULL,
    [ChangeType] TINYINT      NOT NULL,
    [GroupID]    INT          CONSTRAINT [DF_MoneySourceType_GroupID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MoneySourceType] PRIMARY KEY CLUSTERED ([SourceID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_MoneySourceType_SourceName]
    ON [Stat].[MoneySourceType]([SourceName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 流入 1 流出 2 流通', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceType', @level2type = N'COLUMN', @level2name = N'ChangeType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型名称', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceType', @level2type = N'COLUMN', @level2name = N'SourceName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceType', @level2type = N'COLUMN', @level2name = N'SourceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分组编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'MoneySourceType', @level2type = N'COLUMN', @level2name = N'GroupID';

