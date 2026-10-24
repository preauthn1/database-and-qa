CREATE TABLE [Notify].[CmdWorker] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [CommandType]  INT           NOT NULL,
    [SParam]       VARCHAR (512) NULL,
    [Status]       TINYINT       NOT NULL,
    [CreateTime]   DATETIME      NOT NULL,
    [LastPostTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_CmdQueue] PRIMARY KEY CLUSTERED ([Id] ASC)
);

