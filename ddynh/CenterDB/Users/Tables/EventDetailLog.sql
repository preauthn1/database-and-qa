CREATE TABLE [Users].[EventDetailLog] (
    [ID]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [EventSettingID] INT          CONSTRAINT [DF__EventDeta__Event__73D00A73] DEFAULT ((0)) NOT NULL,
    [EventType]      INT          CONSTRAINT [DF__EventDeta__Event__74C42EAC] DEFAULT ((0)) NOT NULL,
    [UserID]         INT          NOT NULL,
    [LoginName]      VARCHAR (32) NULL,
    [CreateTime]     DATETIME     NOT NULL,
    [GiftCash]       BIGINT       NOT NULL,
    [IPAddress]      VARCHAR (40) NOT NULL,
    CONSTRAINT [PK_EventDetailLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_EventDetailLog_UserID]
    ON [Users].[EventDetailLog]([UserID] ASC)
    INCLUDE([CreateTime], [GiftCash], [IPAddress]);


GO


