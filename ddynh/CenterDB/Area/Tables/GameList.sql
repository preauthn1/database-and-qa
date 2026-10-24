CREATE TABLE [Area].[GameList] (
    [Id]         INT     IDENTITY (1, 1) NOT NULL,
    [PlatformID] INT     NOT NULL,
    [GameID]     INT     NOT NULL,
    [Sort]       INT     NOT NULL,
    [Status]     TINYINT DEFAULT ((0)) NULL,
    [Popular]    TINYINT CONSTRAINT [DF_GameList_Popular] DEFAULT ((0)) NOT NULL,
    [AreaID]     INT     NULL,
    [IconID]     INT     NULL,
    CONSTRAINT [PK_GameList_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_GameList_GameID]
    ON [Area].[GameList]([PlatformID] ASC, [GameID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台游戏记录', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'GameList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'GameList', @level2type = N'COLUMN', @level2name = N'GameID';

