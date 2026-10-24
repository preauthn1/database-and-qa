CREATE TABLE [dbo].[CPUEvent] (
    [LogID]     BIGINT   IDENTITY (1, 1) NOT NULL,
    [SQL_Pct]   INT      CONSTRAINT [DF_CPUEvent_CPU_Num] DEFAULT ((0)) NULL,
    [Idle_Pct]  INT      CONSTRAINT [DF_CPUEvent_Idle_Pct] DEFAULT ((0)) NULL,
    [Other_Pct] INT      CONSTRAINT [DF_CPUEvent_Usage_Pct] DEFAULT ((0)) NULL,
    [EventTime] DATETIME NULL,
    CONSTRAINT [PK_CPUEvent] PRIMARY KEY CLUSTERED ([LogID] ASC)
);

