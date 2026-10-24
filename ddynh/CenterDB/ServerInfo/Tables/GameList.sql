CREATE TABLE [ServerInfo].[GameList] (
    [GameID]         INT            NOT NULL,
    [GameName]       VARCHAR (64)   NOT NULL,
    [AndroidVersion] VARCHAR (1024) NOT NULL,
    [IOSVersion]     VARCHAR (1024) NOT NULL,
    [Status]         TINYINT        NOT NULL,
    [ShortName]      VARCHAR (10)   NULL,
    CONSTRAINT [PK_GameList] PRIMARY KEY CLUSTERED ([GameID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_GameList_GameName]
    ON [ServerInfo].[GameList]([GameName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏状态 0 维护中 1正常', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'IOSVersion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏名称', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'GameName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'安卓版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'AndroidVersion';

