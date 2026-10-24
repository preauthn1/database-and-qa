CREATE TABLE [Users].[GradeDetail] (
    [Id]             INT        IDENTITY (1, 1) NOT NULL,
    [UserID]         INT        NOT NULL,
    [GradeID]        INT        NOT NULL,
    [IPAddress]      NCHAR (50) NOT NULL,
    [CreateTime]     DATETIME   NOT NULL,
    [LastUpdateTime] DATETIME   NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

