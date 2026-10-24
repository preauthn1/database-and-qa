CREATE TABLE [Payment].[PayGatewayConvertTypeMapping] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [GWID]        INT NOT NULL,
    [ConvertType] INT NOT NULL,
    CONSTRAINT [PK_PayGatewayConvertTypeMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代付类型，请参考 ConvertTypeEnum', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGatewayConvertTypeMapping', @level2type = N'COLUMN', @level2name = N'ConvertType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支付GWID', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGatewayConvertTypeMapping', @level2type = N'COLUMN', @level2name = N'GWID';

