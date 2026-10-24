CREATE TABLE [Game].[SuperTool_JDESYD_SystemPoolSetting] (
    [FlagID]        INT NOT NULL,
    [AreaNo]        INT NOT NULL,
    [XVariation]    INT CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolSetting_XVariation] DEFAULT ((0)) NOT NULL,
    [ConditionOdds] INT CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolSetting_ConditionOdds] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SuperTool_JDESYD_SystemPoolSetting] PRIMARY KEY CLUSTERED ([FlagID] ASC, [AreaNo] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'輸贏區間', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolSetting', @level2type = N'COLUMN', @level2name = N'ConditionOdds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'變數加減，千分比，例如值 50 表示 0.050', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolSetting', @level2type = N'COLUMN', @level2name = N'XVariation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'區間編號', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolSetting', @level2type = N'COLUMN', @level2name = N'AreaNo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間編號', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolSetting', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'動態水線區間表', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolSetting';

