CREATE TABLE [Game].[JackpotPool_Link] (
    [GameID]            INT    NOT NULL,
    [LevelID]           INT    NOT NULL,
    [Contribution]      BIGINT NOT NULL,
    [TotalContribution] BIGINT NOT NULL,
    [AwardTotal]        BIGINT NOT NULL,
    [FlagID]            INT    CONSTRAINT [DF_JackpotPool_Link_FlagID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_JackpotPool_Link] PRIMARY KEY CLUSTERED ([GameID] ASC, [LevelID] ASC, [FlagID] ASC)
);

