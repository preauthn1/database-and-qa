CREATE TABLE [Game].[JackpotPool_NoLink] (
    [GameID]            INT    NOT NULL,
    [TableNo]           INT    NOT NULL,
    [LevelID]           INT    NOT NULL,
    [Contribution]      BIGINT NOT NULL,
    [TotalContribution] BIGINT NOT NULL,
    [AwardTotal]        BIGINT NOT NULL,
    [FlagID]            INT    CONSTRAINT [DF_JackpotPool_NoLink_FlagID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_JackpotPool_NoLink] PRIMARY KEY CLUSTERED ([GameID] ASC, [TableNo] ASC, [LevelID] ASC, [FlagID] ASC)
);



