CREATE TABLE [Game].[Poker_JackpotPool_NoLink] (
    [GameID]            INT    NOT NULL,
    [TableNo]           INT    NOT NULL,
    [LevelID]           INT    NOT NULL,
    [Contribution]      BIGINT NOT NULL,
    [TotalContribution] BIGINT NOT NULL,
    [AwardTotal]        BIGINT NOT NULL,
    [JackpotPool]       BIGINT NOT NULL,
    [FlagID]            INT    CONSTRAINT [DF_Poker_JackpotPool_NoLink_FlagID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Poker_JackpotPool_NoLink] PRIMARY KEY CLUSTERED ([GameID] ASC, [TableNo] ASC, [LevelID] ASC, [FlagID] ASC)
);

