CREATE TABLE [dbo].[ApiRequestLog_GameApi] (
    [Id]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RequestUrl]         NVARCHAR (MAX) NOT NULL,
    [Doamin]             NVARCHAR (200) NOT NULL,
    [RelativeUrl]        NVARCHAR (200) NOT NULL,
    [HttpMethod]         NVARCHAR (10)  NOT NULL,
    [RequestBody]        NVARCHAR (MAX) NOT NULL,
    [ResponseText]       NVARCHAR (MAX) NOT NULL,
    [ResponseStatusCode] INT            NOT NULL,
    [ResponseLength]     BIGINT         CONSTRAINT [DF_ApiRequestLog_GameApi_ResponseLength] DEFAULT ((0)) NOT NULL,
    [IPAddress]          NVARCHAR (50)  NULL,
    [IPLocation]         NVARCHAR (200) NULL,
    [WebSiteName]        NVARCHAR (200) NULL,
    [Memo]               NVARCHAR (500) NULL,
    [Headers]            NVARCHAR (MAX) NULL,
    [UserIdentity]       NVARCHAR (100) NULL,
    [IdentityKey]        NVARCHAR (200) NULL,
    [CreateTime]         DATETIME       NOT NULL,
    [StackTrace]         NVARCHAR (MAX) NULL,
    [DebugInfo]          NVARCHAR (MAX) NULL,
    [DebugInfo2]         NVARCHAR (MAX) NULL,
    [DebugInfo3]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ApiRequestLog_GameApi] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_ApiRequestLog_GameApi_IdentityKey]
    ON [dbo].[ApiRequestLog_GameApi]([IdentityKey] ASC);


GO
CREATE CLUSTERED INDEX [IX_ApiRequestLog_GameApi_CreateTime]
    ON [dbo].[ApiRequestLog_GameApi]([CreateTime] ASC);



