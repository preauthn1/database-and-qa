CREATE TABLE [Pay].[PayTypSort] (
    [PlatformID] INT NOT NULL,
    [AreaID]     INT NOT NULL,
    [TypeID]     INT NOT NULL,
    [Sort]       INT NOT NULL,
    CONSTRAINT [PK_PayTypSort] PRIMARY KEY CLUSTERED ([PlatformID] ASC, [AreaID] ASC, [TypeID] ASC)
);

