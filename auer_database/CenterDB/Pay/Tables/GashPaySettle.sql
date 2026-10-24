CREATE TABLE [Pay].[GashPaySettle] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [MsgType]        NVARCHAR (100) NULL,
    [PCode]          NVARCHAR (100) NULL,
    [CID]            NVARCHAR (100) NOT NULL,
    [COID]           NVARCHAR (100) NOT NULL,
    [CUID]           NVARCHAR (100) NOT NULL,
    [PAID]           NVARCHAR (100) NOT NULL,
    [Amount]         NVARCHAR (100) NOT NULL,
    [ERQC]           NVARCHAR (100) NOT NULL,
    [IsSuccess]      BIT            NOT NULL,
    [LastUpdateTime] DATETIME       NOT NULL
);

