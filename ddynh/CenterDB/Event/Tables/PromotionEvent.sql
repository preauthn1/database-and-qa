CREATE TABLE [Event].[PromotionEvent] (
    [EventId]          INT            IDENTITY (150000, 1) NOT NULL,
    [Title]            NVARCHAR (200) NOT NULL,
    [Memo]             NVARCHAR (200) NULL,
    [Status]           INT            NOT NULL,
    [EventStartTime]   DATETIME       NOT NULL,
    [EventEndTime]     DATETIME       NOT NULL,
    [CreateTime]       DATETIME       NOT NULL,
    [UpdateTime]       DATETIME       NOT NULL,
    [UpdateBy]         NVARCHAR (50)  NULL,
    [ParentTemplateID] INT            NULL,
    [PlatformID]       INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PromotionEvent] PRIMARY KEY CLUSTERED ([EventId] ASC)
);







