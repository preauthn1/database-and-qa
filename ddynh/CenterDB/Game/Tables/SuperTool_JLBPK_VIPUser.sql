CREATE TABLE [Game].[SuperTool_JLBPK_VIPUser] (
    [UserID]           INT          NOT NULL,
    [UserWeight]       INT          CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_UserWeight] DEFAULT ((0)) NOT NULL,
    [TargetMoney]      BIGINT       CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_TargetMoney] DEFAULT ((0)) NOT NULL,
    [AccumulatedMoney] BIGINT       CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_AccumulatedMoney] DEFAULT ((0)) NOT NULL,
    [Finish]           TINYINT      CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_Finish] DEFAULT ((0)) NOT NULL,
    [Status]           TINYINT      CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_Status] DEFAULT ((0)) NOT NULL,
    [Operator]         VARCHAR (50) NOT NULL,
    [CreateTime]       DATETIME     NOT NULL,
    [LastUpdateTime]   DATETIME     CONSTRAINT [DF_SuperTool_JLBPK_VIPUser_LastUpdateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SuperTool_JLBPK_VIPUser] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'建立日期', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'操作人員', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'Operator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'累積金額', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'AccumulatedMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家目標金額', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'TargetMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家拿牌權重', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'UserWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'加勒比海棋牌-監控玩家', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'SuperTool_JLBPK_VIPUser';

