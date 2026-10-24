CREATE TABLE [Pay].[ConvertGatewayBankSetting] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ConvertGatewayID]   INT            NOT NULL,
    [UnionpayBankCodeID] INT            NOT NULL,
    [Status]             INT            NOT NULL,
    [ThirdPartyBankCode] NVARCHAR (200) NULL,
    CONSTRAINT [PK_ConvertGatewayBankSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'三方金流自行定義的bankCode', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGatewayBankSetting', @level2type = N'COLUMN', @level2name = N'ThirdPartyBankCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'管理三方代付可支援銀行', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGatewayBankSetting';

