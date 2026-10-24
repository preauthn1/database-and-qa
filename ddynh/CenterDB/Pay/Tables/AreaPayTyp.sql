CREATE TABLE [Pay].[AreaPayTyp] (
    [PlatformID] INT     NOT NULL,
    [AreaID]     INT     NOT NULL,
    [GWID]       INT     NOT NULL,
    [TypeID]     INT     NOT NULL,
    [Priority]   TINYINT NOT NULL,
    CONSTRAINT [PK_AreaPayTyp] PRIMARY KEY CLUSTERED ([PlatformID] ASC, [AreaID] ASC, [GWID] ASC, [TypeID] ASC)
);

