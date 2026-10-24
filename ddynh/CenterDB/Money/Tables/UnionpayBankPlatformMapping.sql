CREATE TABLE [Money].[UnionpayBankPlatformMapping] (
    [Id]                 INT IDENTITY (1, 1) NOT NULL,
    [UnionpayBankCodeID] INT NOT NULL,
    [PlatformID]         INT NOT NULL,
    CONSTRAINT [PK_UnionpayBankPlatformMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

