CREATE TABLE [Game].[SuperTool_JLBPK_Setting] (
    [FlagID]            INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_FlagID] DEFAULT ((0)) NOT NULL,
    [FlowBase]          BIGINT CONSTRAINT [DF_SuperTool_JLBPK_Setting_FlowBase] DEFAULT ((0)) NOT NULL,
    [PlayerWeight]      INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_PlayerWeight] DEFAULT ((0)) NOT NULL,
    [DealerWeight]      INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_DealerWeight] DEFAULT ((0)) NOT NULL,
    [DealerTargetMoney] BIGINT CONSTRAINT [DF_SuperTool_JLBPK_Setting_DealerTargetMoney] DEFAULT ((0)) NOT NULL,
    [CheatRate]         INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_CheatRate] DEFAULT ((0)) NOT NULL,
    [DealerWin]         INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_DealerWin] DEFAULT ((0)) NOT NULL,
    [PlayerWin]         INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_PlayerWin] DEFAULT ((0)) NOT NULL,
    [DealerNotGood]     INT    CONSTRAINT [DF_SuperTool_JLBPK_Setting_DealerNotGood] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SuperTool_JLBPK_Setting] PRIMARY KEY CLUSTERED ([FlagID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'莊家不成局局數', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'DealerNotGood';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家勝利局數', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'PlayerWin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'莊家勝利局數', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'DealerWin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'換牌機率', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'CheatRate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'莊家目標金額', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'DealerTargetMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'預設莊家拿牌權重', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'DealerWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'預設玩家拿牌權重', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'PlayerWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'水線基準', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'FlowBase';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間編號，1:初級場，2:中級場，3:高級場', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'加勒比海棋牌-超端设定', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_Setting';

