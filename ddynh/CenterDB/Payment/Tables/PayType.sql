CREATE TABLE [Payment].[PayType] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [GWID]           BIGINT         NOT NULL,
    [Type]           TINYINT        NOT NULL,
    [Currencies]     VARCHAR (3)    NOT NULL,
    [BankCode]       NVARCHAR (50)  NOT NULL,
    [minAmount]      INT            DEFAULT ((0)) NOT NULL,
    [maxAmount]      INT            DEFAULT ((0)) NOT NULL,
    [amountFixed]    BIT            NULL,
    [fixedAmount]    NVARCHAR (MAX) NULL,
    [Status]         TINYINT        DEFAULT ((0)) NOT NULL,
    [CreateTime]     DATETIME       NOT NULL,
    [LastUpdateTime] DATETIME       NULL,
    CONSTRAINT [PK_Payment_PayType] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'狀態; 1:enable, 2:disable, 3:closed', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Type為2時內容為NULL', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'fixedAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Type為2時內容為NULL', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'amountFixed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1:payin 2:payout', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Payment.PayGateway.ID', @level0type = N'SCHEMA', @level0name = N'Payment', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'GWID';

