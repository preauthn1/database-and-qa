CREATE TABLE [PerLog].[PerGameLogError] (
    [Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [ServerID]    INT           NULL,
    [GameData]    VARCHAR (MAX) NULL,
    [UserGameRet] VARCHAR (MAX) NULL,
    [TaxAmount]   BIGINT        NULL,
    [BeginTime]   DATETIME      NULL,
    [EndTime]     DATETIME      NULL,
    [GameID]      INT           NULL,
    [days]        INT           NULL,
    CONSTRAINT [PK_PerGameLogError] PRIMARY KEY CLUSTERED ([Id] ASC)
);



