CREATE TABLE [Stat].[StatisticsPerGameDetailLog_Hour] (
    [LogID]         BIGINT   IDENTITY (1, 1) NOT NULL,
    [GameID]        INT      NOT NULL,
    [UserID]        INT      NOT NULL,
    [GradeID]       INT      NOT NULL,
    [GameTime]      DATETIME NOT NULL,
    [BetAmount]     BIGINT   NOT NULL,
    [BetCount]      INT      NOT NULL,
    [FlowAmount]    BIGINT   NOT NULL,
    [WinLostAmount] BIGINT   NOT NULL,
    [PlatformID]    INT      NOT NULL,
    [AreaID]        INT      NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'公司輸贏', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'StatisticsPerGameDetailLog_Hour', @level2type = N'COLUMN', @level2name = N'WinLostAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流水', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'StatisticsPerGameDetailLog_Hour', @level2type = N'COLUMN', @level2name = N'FlowAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'下注筆數', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'StatisticsPerGameDetailLog_Hour', @level2type = N'COLUMN', @level2name = N'BetCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'賭注', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'StatisticsPerGameDetailLog_Hour', @level2type = N'COLUMN', @level2name = N'BetAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用戶等級(當時)', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'StatisticsPerGameDetailLog_Hour', @level2type = N'COLUMN', @level2name = N'GradeID';


GO
CREATE CLUSTERED INDEX [IX_StatisticsPerGameDetailLog_Hour_GameTime]
    ON [Stat].[StatisticsPerGameDetailLog_Hour]([GameTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StatisticsPerGameDetailLog_Hour_2]
    ON [Stat].[StatisticsPerGameDetailLog_Hour]([GameID] ASC, [PlatformID] ASC, [AreaID] ASC, [UserID] ASC);

