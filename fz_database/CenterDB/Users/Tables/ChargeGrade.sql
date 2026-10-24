CREATE TABLE [Users].[ChargeGrade] (
    [Id]      INT    NOT NULL,
    [Amount]  BIGINT NOT NULL,
    [Company] INT    NOT NULL,
    CONSTRAINT [PK_ChargeGrade] PRIMARY KEY CLUSTERED ([Id] ASC, [Company] ASC)
);

