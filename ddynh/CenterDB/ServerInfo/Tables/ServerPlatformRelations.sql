CREATE TABLE [ServerInfo].[ServerPlatformRelations] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [PlatformID] INT NOT NULL,
    [GameID]     INT NOT NULL,
    [ServerID]   INT NOT NULL,
    [Status]     BIT NOT NULL,
    CONSTRAINT [PK_ServerPlatformRelations] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [UQ_ServerPlatformRelations_PlatformID_ServerID] UNIQUE NONCLUSTERED ([PlatformID] ASC, [ServerID] ASC)
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0: disabled, 1: enabled', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'ServerPlatformRelations', @level2type = N'COLUMN', @level2name = N'Status';

