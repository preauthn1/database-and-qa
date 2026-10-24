CREATE TABLE [Payment].[PlatformPayTypeSetting] (
    [ID]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [PayTypeID]      BIGINT        NOT NULL,
    [PlatformID]     BIGINT        NOT NULL,
    [MinAmount]      INT           NULL,
    [MaxAmount]      INT           NULL,
    [AmountFixed]    TINYINT       NULL,
    [FixedAmount]    VARCHAR (100) NULL,
    [Status]         TINYINT       NOT NULL,
    [CreateTime]     DATETIME      NULL,
    [LastUpdateTime] DATETIME      NULL,
    [Priority]       INT           CONSTRAINT [DF__PlatformP__Prior__2F5AE495] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Payment_PlatformPayTypeSetting] PRIMARY KEY CLUSTERED ([ID] ASC)
);



