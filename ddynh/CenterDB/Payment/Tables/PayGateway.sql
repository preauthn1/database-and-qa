CREATE TABLE [Payment].[PayGateway] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [GatewayCode]    VARCHAR (20)   NOT NULL,
    [GatewayName]    VARCHAR (20)   NOT NULL,
    [MerchantInfo]   INT            CONSTRAINT [DF__PayGatewa__Merch__3E88198C] DEFAULT ((0)) NOT NULL,
    [SettingInfo]    NVARCHAR (MAX) NULL,
    [SupportPayin]   BIT            CONSTRAINT [DF__PayGatewa__Suppo__3F7C3DC5] DEFAULT ('FALSE') NOT NULL,
    [SupportPayout]  BIT            CONSTRAINT [DF__PayGatewa__Suppo__407061FE] DEFAULT ('FALSE') NOT NULL,
    [ReviseAmount]   BIT            CONSTRAINT [DF__PayGatewa__Revis__41648637] DEFAULT ('FALSE') NOT NULL,
    [BankCodes]      NVARCHAR (MAX) NULL,
    [Active]         TINYINT        NULL,
    [Status]         TINYINT        CONSTRAINT [DF__PayGatewa__Statu__4258AA70] DEFAULT ((0)) NOT NULL,
    [CreateTime]     DATETIME       NOT NULL,
    [LastUpdateTime] DATETIME       NULL,
    [Url]            NVARCHAR (100) NULL,
    [Systems]        TINYINT        CONSTRAINT [DF__PayGatewa__Syste__0599B4F3] DEFAULT ((1)) NOT NULL,
    [Sort]           INT            CONSTRAINT [DF_PayGateway_Sort] DEFAULT ((0)) NOT NULL,
    [UpdateBy]       NVARCHAR (100) NULL,
    CONSTRAINT [PK_Payment_PayGateway] PRIMARY KEY CLUSTERED ([ID] ASC)
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支援之銀行代碼', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'BankCodes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否會調整金額', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'ReviseAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支援代付交易', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'SupportPayout';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支援代收交易', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'SupportPayin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所需商務號資訊', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'MerchantInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第三方金流名稱', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'GatewayName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第三方金流代碼', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayGateway', @level2type = N'COLUMN', @level2name = N'GatewayCode';

