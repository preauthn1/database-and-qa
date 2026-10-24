CREATE TABLE [ServerInfo].[GameCategorySetting] (
    [Id]             INT IDENTITY (1, 1) NOT NULL,
    [GameID]         INT NOT NULL,
    [GameCategoryID] INT NOT NULL,
    CONSTRAINT [PK_GameCategorySetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

