CREATE TABLE [Event].[EventSettingRuleItem] (
    [Id]             INT             IDENTITY (1, 1) NOT NULL,
    [EventSettingID] INT             NOT NULL,
    [BonusGroup]     INT             CONSTRAINT [DF__EventSett__Bonus__06E2DEE7] DEFAULT ((0)) NOT NULL,
    [RuleGroupID]    INT             NOT NULL,
    [RuleType]       INT             NOT NULL,
    [RuleValue]      BIGINT          NOT NULL,
    [RuleValueText]  NVARCHAR (2048) NULL,
    CONSTRAINT [PK_EventSettingRuleItem] PRIMARY KEY CLUSTERED ([Id] ASC)
);



