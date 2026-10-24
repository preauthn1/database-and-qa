CREATE TABLE [dbo].[BlockingLog] (
    [LogID]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [LogTime]             DATETIME       NULL,
    [DBName]              VARCHAR (128)  NULL,
    [request_session_id]  INT            NULL,
    [blocking_session_id] INT            NULL,
    [BlockedObjectName]   VARCHAR (128)  NULL,
    [resource_type]       VARCHAR (128)  NULL,
    [RequestingText]      NVARCHAR (MAX) NULL,
    [BlockingText]        NVARCHAR (MAX) NULL,
    [Request_mode]        VARCHAR (128)  NULL,
    [Wait_duration_ms]    INT            NULL,
    [Wait_type]           VARCHAR (128)  NULL,
    CONSTRAINT [PK_BlockingLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);

