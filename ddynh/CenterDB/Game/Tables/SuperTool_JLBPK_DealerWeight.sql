CREATE TABLE [Game].[SuperTool_JLBPK_DealerWeight] (
    [DealerWeightID] INT      IDENTITY (1, 1) NOT NULL,
    [FlagID]         INT      CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_FlagID] DEFAULT ((0)) NOT NULL,
    [TableNo]        INT      CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_TableNo] DEFAULT ((0)) NOT NULL,
    [CardPattern]    INT      CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_CardPattern] DEFAULT ((0)) NOT NULL,
    [Weight]         INT      CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_Weight] DEFAULT ((0)) NOT NULL,
    [CreateTime]     DATETIME CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_CreateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdateTime] DATETIME CONSTRAINT [DF_SuperTool_JLBPK_DealerWeight_LastUpdateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SuperTool_JLBPK_DealerWeight] PRIMARY KEY NONCLUSTERED ([DealerWeightID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'資料維護時間', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'LastUpdateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'資料建立時間', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'權重值', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'Weight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'牌型編號', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'CardPattern';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'莊家牌型表表號，0 = A 情況、1 = B 情況，依此類推', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'TableNo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間類型，1:初級場，2:中級場，3:高級場', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流水編號', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight', @level2type = N'COLUMN', @level2name = N'DealerWeightID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'庄家牌型权重', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_DealerWeight';

