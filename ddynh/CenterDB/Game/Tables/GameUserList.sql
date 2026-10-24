CREATE TABLE [Game].[GameUserList] (
    [UserID]   INT      NOT NULL,
    [ServerID] SMALLINT NOT NULL,
    [HDType]   TINYINT  NOT NULL
);




GO
CREATE NONCLUSTERED INDEX [IDX_GameUserList_UserID]
    ON [Game].[GameUserList]([UserID] ASC)
    INCLUDE([ServerID]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏在线用户', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameUserList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameUserList', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameUserList', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameUserList', @level2type = N'COLUMN', @level2name = N'HDType';

