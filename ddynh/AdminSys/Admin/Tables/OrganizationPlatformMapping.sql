CREATE TABLE [Admin].[OrganizationPlatformMapping] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [OrgID]      INT NOT NULL,
    [PlatformID] INT NOT NULL,
    CONSTRAINT [PK_OrganizationPlatformMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

