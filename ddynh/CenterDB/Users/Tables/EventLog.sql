CREATE TABLE [Users].[EventLog] (
    [EventSettingID] INT          CONSTRAINT [DF__EventLog__EventS__72DBE63A] DEFAULT ((0)) NOT NULL,
    [UserID]         INT          NOT NULL,
    [EventType]      INT          CONSTRAINT [DF__EventLog__EventT__71E7C201] DEFAULT ((0)) NOT NULL,
    [LoginName]      VARCHAR (32) NULL,
    [Updater]        VARCHAR (20) NULL,
    [UpdateTime]     DATETIME     NULL,
    [GrantTimes]     TINYINT      NULL,
    CONSTRAINT [PK_EventLog_1] PRIMARY KEY CLUSTERED ([UserID] ASC, [EventSettingID] ASC)
);




GO


