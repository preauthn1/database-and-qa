CREATE TABLE [ServerInfo].[GameCategory] (
    [Id]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (50) NOT NULL,
    [Status] INT           CONSTRAINT [DF_GameCategory_Status] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_GameCategory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

