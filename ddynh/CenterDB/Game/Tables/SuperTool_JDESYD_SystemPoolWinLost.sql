CREATE TABLE [Game].[SuperTool_JDESYD_SystemPoolWinLost] (
    [FlagID]     INT    NOT NULL,
    [AverageBet] BIGINT CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolWinLost_AverageBet] DEFAULT ((60)) NOT NULL,
    [Factor]     INT    CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolWinLost_Factor] DEFAULT ((20)) NOT NULL,
    [BetMoney]   BIGINT CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolWinLost_BetMoney] DEFAULT ((0)) NOT NULL,
    [BetCount]   INT    CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolWinLost_BetCount] DEFAULT ((0)) NOT NULL,
    [PoolAmount] BIGINT CONSTRAINT [DF_SuperTool_JDESYD_SystemPoolWinLost_PoolAmount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SuperTool_JDESYD_SystemPoolWinLost] PRIMARY KEY CLUSTERED ([FlagID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'水池量', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'PoolAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'下注總次數', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'BetCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'下注金額', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'BetMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'係數定值', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'Factor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平均押注', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'AverageBet';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'房間編號', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost', @level2type = N'COLUMN', @level2name = N'FlagID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'水池設置表', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JDESYD_SystemPoolWinLost';

