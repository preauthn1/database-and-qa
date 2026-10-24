CREATE TABLE [Event].[PromotionEventItem] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [EventID]              INT             NOT NULL,
    [Type]                 INT             NOT NULL,
    [ImageUrlDomain]       NVARCHAR (500)  NULL,
    [ImageUrl]             NVARCHAR (MAX)  NULL,
    [Status]               INT             NOT NULL,
    [Sort]                 INT             NOT NULL,
    [Tags]                 INT             NOT NULL,
    [BehaviorType]         INT             NOT NULL,
    [BehaviorSettingValue] NVARCHAR (1000) NULL,
    [DisplayMode]          INT             DEFAULT ((0)) NOT NULL,
    [Content]              NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_PromotionEventItem_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);





