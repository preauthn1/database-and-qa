CREATE TABLE [Game].[WinAnnConfig] (
    [GameID]     INT    NOT NULL,
    [UpperLimit] BIGINT NOT NULL,
    CONSTRAINT [PK_WinLoseAnnConfig_GameID] PRIMARY KEY CLUSTERED ([GameID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'赢了通知配置', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WinAnnConfig';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'自动通知金额上限', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WinAnnConfig', @level2type = N'COLUMN', @level2name = N'UpperLimit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WinAnnConfig', @level2type = N'COLUMN', @level2name = N'GameID';

