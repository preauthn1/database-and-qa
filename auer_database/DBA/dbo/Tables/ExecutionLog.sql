CREATE TABLE [dbo].[ExecutionLog] (
    [LogID]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [objtype]             VARCHAR (100)   NULL,
    [plan_handle]         VARBINARY (MAX) NULL,
    [sql_handle]          VARBINARY (MAX) NULL,
    [creation_time]       DATETIME        NULL,
    [last_execution_time] DATETIME        NULL,
    [execution_time]      INT             NULL,
    [avg_physical_reads]  INT             NULL,
    [avg_logical_reads]   INT             NULL,
    [avg_logical_writes]  INT             NULL,
    [avg_elapsed_time]    INT             NULL,
    [sql_text]            NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_ExecutionLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);

