CREATE TABLE [Users].[EventSetting] (
    [ID]         INT            IDENTITY (25000, 1) NOT NULL,
    [EventID]    INT            NOT NULL,
    [EventName]  NVARCHAR (100) NOT NULL,
    [StartTime]  DATETIME       NOT NULL,
    [EndTime]    DATETIME       NOT NULL,
    [Status]     INT            CONSTRAINT [DF_EventSetting_Status] DEFAULT ((1)) NOT NULL,
    [GiftCash]   BIGINT         CONSTRAINT [DF_EventSetting_GiftCash] DEFAULT ((0)) NOT NULL,
    [Updater]    NVARCHAR (100) NULL,
    [UpdateTime] DATETIME       NOT NULL,
    [EventType]  INT            CONSTRAINT [DF__EventSett__Event__4420F751] DEFAULT ((0)) NOT NULL,
    [PlatformID] INT            CONSTRAINT [DF__EventSett__Platf__45151B8A] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EventSetting_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_EventSetting_EventName]
    ON [Users].[EventSetting]([EventName] ASC);


GO


