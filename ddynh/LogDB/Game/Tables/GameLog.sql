CREATE TABLE [Game].[GameLog] (
    [LogID]      INT          IDENTITY (1, 1) NOT NULL,
    [UserID]     INT          NOT NULL,
    [ServerID]   INT          NOT NULL,
    [LoginMoney] BIGINT       NOT NULL,
    [Amount]     BIGINT       NOT NULL,
    [TaxAmount]  BIGINT       NOT NULL,
    [WinCount]   INT          NOT NULL,
    [LoseCount]  INT          NOT NULL,
    [DrawCount]  INT          NOT NULL,
    [GameTime]   INT          NOT NULL,
    [IPAddress]  VARCHAR (15) NOT NULL,
    [HDCode]     VARCHAR (64) NOT NULL,
    [HDType]     TINYINT      NOT NULL,
    [LoginTime]  DATETIME     NOT NULL,
    [LogoutTime] DATETIME     NOT NULL,
    [GameID]     INT          NULL,
    [AreaID]     INT          NULL,
    [PlatformID] INT          NULL,
    [TradeID]    BIGINT       DEFAULT ((0)) NOT NULL,
    [FlowAmount] BIGINT       NULL
) ON [S_Data] ([LogoutTime]);




GO
CREATE CLUSTERED INDEX [IUX_GameLog_LogoutTime]
    ON [Game].[GameLog]([LogoutTime] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_LogID]
    ON [Game].[GameLog]([LogID] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_ServerID]
    ON [Game].[GameLog]([ServerID] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_HDCode]
    ON [Game].[GameLog]([HDCode] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_IPAddress]
    ON [Game].[GameLog]([IPAddress] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_UserID_TradeID]
    ON [Game].[GameLog]([UserID] ASC, [TradeID] ASC)
    ON [S_Data] ([LogoutTime]);


GO
CREATE NONCLUSTERED INDEX [IX_GameLog_GameID]
    ON [Game].[GameLog]([GameID] ASC, [LoginTime] ASC)
    INCLUDE([UserID])
    ON [PRIMARY];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏记录', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'赢的局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'WinCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'输的局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'LoseCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登出时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'LogoutTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'进入房间时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'LoginTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'进游戏金币数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'LoginMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'HDType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件唯一编码', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'HDCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'GameTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'DrawCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameLog', @level2type = N'COLUMN', @level2name = N'Amount';

