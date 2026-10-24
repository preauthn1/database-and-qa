CREATE TABLE [Payment].[PayTypeCategoryMapping] (
    [Id]              INT IDENTITY (1, 1) NOT NULL,
    [SourcePayType]   INT NOT NULL,
    [RelationPayType] INT NOT NULL,
    [IsFixedAmount]   BIT NOT NULL,
    CONSTRAINT [PK_PayTypeCategory] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'若設為true，代表要去查詢isRange為true的支付', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayTypeCategoryMapping', @level2type = N'COLUMN', @level2name = N'IsFixedAmount';

