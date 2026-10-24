CREATE TABLE [Money].[UnionpayBankCode] (
    [Id]         INT            IDENTITY (900, 1) NOT NULL,
    [Code]       VARCHAR (5)    NOT NULL,
    [BankName]   VARCHAR (50)   NOT NULL,
    [Show]       BIT            CONSTRAINT [DF_UnionpayBankCode_Show] DEFAULT ((1)) NOT NULL,
    [BankID]     VARCHAR (50)   NULL,
    [CreateTime] DATETIME       CONSTRAINT [DF__UnionpayB__Creat__396E5EB4] DEFAULT (getdate()) NOT NULL,
    [UpdateTime] DATETIME       CONSTRAINT [DF__UnionpayB__Updat__3A6282ED] DEFAULT (getdate()) NOT NULL,
    [UpdateBy]   NVARCHAR (200) CONSTRAINT [DF__UnionpayB__Updat__3B56A726] DEFAULT ('') NULL,
    CONSTRAINT [PK_UnionpayBankCode] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_UnionpayBankCode_Code] UNIQUE NONCLUSTERED ([Code] ASC)
);








GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'銀聯卡銀行清單', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'UnionpayBankCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否顯示於前端', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'UnionpayBankCode', @level2type = N'COLUMN', @level2name = N'Show';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'銀行代號', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'UnionpayBankCode', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'銀行名稱', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'UnionpayBankCode', @level2type = N'COLUMN', @level2name = N'BankName';


GO


