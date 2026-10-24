CREATE TABLE [Pay].[PayType] (
    [GWID]         INT           NOT NULL,
    [TypeID]       INT           NOT NULL,
    [TypeName]     VARCHAR (32)  NOT NULL,
    [TradeCode]    VARCHAR (20)  CONSTRAINT [DF_PayType_TradeCode] DEFAULT ((0)) NOT NULL,
    [SourceTypeID] INT           NOT NULL,
    [Scale]        INT           NOT NULL,
    [Status]       TINYINT       NOT NULL,
    [AmountSort]   VARCHAR (512) NULL,
    [IsRange]      BIT           NULL,
    [MinValue]     BIGINT        NULL,
    [MaxValue]     BIGINT        NULL,
    CONSTRAINT [PK_PayType] PRIMARY KEY CLUSTERED ([GWID] ASC, [TypeID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 停用 1启用 2不显示在后台', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支付渠道', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道名称', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'TypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道编号', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'TypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流通类型编号', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'SourceTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值比例（1 块钱充值金币数量）', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'PayType', @level2type = N'COLUMN', @level2name = N'Scale';

