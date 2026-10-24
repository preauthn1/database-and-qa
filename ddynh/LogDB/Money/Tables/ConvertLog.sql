CREATE TABLE [Money].[ConvertLog] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]         INT           NOT NULL,
    [Amount]         BIGINT        NOT NULL,
    [TaxAmount]      BIGINT        CONSTRAINT [DF_ConvertLog_TaxAmount] DEFAULT ((0)) NOT NULL,
    [RealTaxAmount]  BIGINT        CONSTRAINT [DF_ConvertLog_RealTaxAmount] DEFAULT ((0)) NOT NULL,
    [Status]         TINYINT       NOT NULL,
    [ConvertType]    TINYINT       NOT NULL,
    [RealName]       VARCHAR (64)  NOT NULL,
    [Account]        VARCHAR (64)  NOT NULL,
    [BankName]       VARCHAR (50)  NULL,
    [CreateIP]       VARCHAR (15)  NOT NULL,
    [TransID]        VARCHAR (64)  NULL,
    [TransData]      VARCHAR (MAX) NULL,
    [CreateTime]     DATETIME      NOT NULL,
    [LastUpdateTime] DATETIME      NOT NULL,
    [CheckTime]      DATETIME      NOT NULL,
    [PlatformID]     INT           NULL,
    [AreaID]         INT           NULL,
    [BankAmount]     BIGINT        NULL,
    [CashAmount]     BIGINT        NULL,
    [Operator]       VARCHAR (16)  NULL,
    [Memo]           VARCHAR (200) NULL,
    [GWID]           INT           NULL,
    CONSTRAINT [PK_ConvertLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_ConvertLog_UserID]
    ON [Money].[ConvertLog]([UserID] ASC, [Amount] ASC, [CreateTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换记录', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'真实手续费', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'RealTaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 提出兑换 1 审核中 2 审核通过 3 已打款 4 订单异常 5 异常帐号 6 黑名单 7 账户错误 8 拒绝兑换 9 疑似洗钱 10 补单完成 11 退还金币 98 人工处理 99 排程处理', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支付寶1, 銀聯卡2', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'ConvertType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户ID', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第三方交易记录编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'TransID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第三方交易数据', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'TransData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换手续费', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'真实姓名', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'RealName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台ID', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'操作者', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Operator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后更新时间', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'LastUpdateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'CreateIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'审核时间', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'CheckTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'錢包餘額', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'CashAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'保險箱餘額', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'BankAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道ID', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'AreaID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换金额', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'備註', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代付渠道ID', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertLog', @level2type = N'COLUMN', @level2name = N'GWID';

