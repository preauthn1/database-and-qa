CREATE TABLE [Game].[UserGameInfo] (
    [Id]          INT    IDENTITY (1, 1) NOT NULL,
    [UserID]      INT    NOT NULL,
    [GameID]      INT    NOT NULL,
    [WinCount]    INT    NOT NULL,
    [LoseCount]   INT    NOT NULL,
    [DrawCount]   INT    NOT NULL,
    [Score]       BIGINT NOT NULL,
    [GameTime]    BIGINT NOT NULL,
    [LastWinLose] INT    DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_UserGameInfo] PRIMARY KEY CLUSTERED ([UserID] ASC, [GameID] ASC) ON [S_UserID] ([UserID])
) ON [S_UserID] ([UserID]);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户游戏信息', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'赢的局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'WinCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'积分', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'Score';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'输的局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'LoseCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏时间(单位秒)', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'GameTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平局数', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'UserGameInfo', @level2type = N'COLUMN', @level2name = N'DrawCount';

