CREATE TABLE [Event].[EvnetSettingBonus] (
    [Id]             INT             IDENTITY (1, 1) NOT NULL,
    [EventSettingID] INT             NOT NULL,
    [BonusGroup]     INT             CONSTRAINT [DF__EvnetSett__Bonus__07D70320] DEFAULT ((0)) NOT NULL,
    [BonusType]      INT             NOT NULL,
    [Value]          DECIMAL (18, 2) NOT NULL,
    [MaxAmountLimit] BIGINT          NULL,
    [FlowRate]       INT             NOT NULL,
    [Sequence]       INT             NOT NULL,
    [DisplayName]    NVARCHAR (200)  NULL,
    [Memo]           NVARCHAR (50)   NULL,
    CONSTRAINT [PK_EvnetSettingBonus] PRIMARY KEY CLUSTERED ([Id] ASC)
);



