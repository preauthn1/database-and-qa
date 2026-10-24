CREATE TABLE [Stat].[AreaDataMonth] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [StatTime]             DATETIME      NOT NULL,
    [PlatformID]           INT           NOT NULL,
    [AreaID]               INT           NOT NULL,
    [GameID]               INT           NULL,
    [ServerID]             INT           NULL,
    [OldLogin]             BIGINT        CONSTRAINT [DF_AreaDataMonth_OldLogin] DEFAULT ((0)) NOT NULL,
    [NewLogin]             BIGINT        CONSTRAINT [DF_AreaDataMonth_NewLogin] DEFAULT ((0)) NOT NULL,
    [OldCharge]            BIGINT        CONSTRAINT [DF_AreaDataMonth_OldCharge] DEFAULT ((0)) NOT NULL,
    [NewCharge]            BIGINT        CONSTRAINT [DF_AreaDataMonth_NewCharge] DEFAULT ((0)) NOT NULL,
    [OldConvert]           BIGINT        CONSTRAINT [DF_AreaDataMonth_OldConvert] DEFAULT ((0)) NOT NULL,
    [NewConvert]           BIGINT        CONSTRAINT [DF_AreaDataMonth_NewConvert] DEFAULT ((0)) NOT NULL,
    [OldConvertTax]        BIGINT        CONSTRAINT [DF_AreaDataMonth_OldConvertTax] DEFAULT ((0)) NOT NULL,
    [NewConvertTax]        BIGINT        CONSTRAINT [DF_AreaDataMonth_NewConvertTax] DEFAULT ((0)) NOT NULL,
    [LoginIP]              BIGINT        CONSTRAINT [DF_AreaDataMonth_LoginIP] DEFAULT ((0)) NOT NULL,
    [OldLoginIP]           BIGINT        CONSTRAINT [DF_AreaDataMonth_OldLoginIP] DEFAULT ((0)) NOT NULL,
    [NewLoginIP]           BIGINT        CONSTRAINT [DF_AreaDataMonth_NewLoginIP] DEFAULT ((0)) NOT NULL,
    [LoginMac]             BIGINT        CONSTRAINT [DF_AreaDataMonth_LoginMac] DEFAULT ((0)) NOT NULL,
    [OldLoginMac]          BIGINT        CONSTRAINT [DF_AreaDataMonth_OldLoginMac] DEFAULT ((0)) NOT NULL,
    [NewLoginMac]          BIGINT        CONSTRAINT [DF_AreaDataMonth_NewLoginMac] DEFAULT ((0)) NOT NULL,
    [GameTax]              BIGINT        CONSTRAINT [DF_AreaDataMonth_GameTax] DEFAULT ((0)) NOT NULL,
    [GameTaxDetail]        VARCHAR (MAX) CONSTRAINT [DF_AreaDataMonth_GameTaxDetail] DEFAULT ('') NOT NULL,
    [Total_OrderUser]      BIGINT        CONSTRAINT [DF_AreaDataMonth_Total_OrderUser] DEFAULT ((0)) NULL,
    [NewOrderUser]         BIGINT        CONSTRAINT [DF_AreaDataMonth_NewOrderUser] DEFAULT ((0)) NULL,
    [iOSCount]             INT           CONSTRAINT [DF_AreaDataMonth_iOSCount] DEFAULT ((0)) NULL,
    [NewiOSCount]          INT           CONSTRAINT [DF_AreaDataMonth_NewiOSCount] DEFAULT ((0)) NULL,
    [AndRoidCount]         INT           CONSTRAINT [DF_AreaDataMonth_AndRoidCount] DEFAULT ((0)) NULL,
    [NewAndRoidCount]      INT           CONSTRAINT [DF_AreaDataMonth_NewAndRoidCount] DEFAULT ((0)) NULL,
    [PCCount]              INT           CONSTRAINT [DF_AreaDataMonth_PCCount] DEFAULT ((0)) NULL,
    [NewPCCount]           INT           CONSTRAINT [DF_AreaDataMonth_NewPCCount] DEFAULT ((0)) NULL,
    [AmountTotal]          BIGINT        CONSTRAINT [DF_AreaDataMonth_AmountTotal] DEFAULT ((0)) NULL,
    [NewAmountTotal]       BIGINT        CONSTRAINT [DF_AreaDataMonth_NewAmountTotal] DEFAULT ((0)) NULL,
    [AmountAvg]            BIGINT        CONSTRAINT [DF_AreaDataMonth_AmountAvg] DEFAULT ((0)) NULL,
    [NewAmountAvg]         BIGINT        CONSTRAINT [DF_AreaDataMonth_NewAmountAvg] DEFAULT ((0)) NULL,
    [TaxAmountTotal]       BIGINT        CONSTRAINT [DF_AreaDataMonth_TaxAmountTotal] DEFAULT ((0)) NULL,
    [NewTaxAmountTotal]    BIGINT        CONSTRAINT [DF_AreaDataMonth_NewTaxAmountTotal] DEFAULT ((0)) NULL,
    [TaxAmountAvg]         BIGINT        CONSTRAINT [DF_AreaDataMonth_TaxAmountAvg] DEFAULT ((0)) NULL,
    [NewTaxAmountAvg]      BIGINT        CONSTRAINT [DF_AreaDataMonth_NewTaxAmountAvg] DEFAULT ((0)) NULL,
    [GameTimeMax]          INT           CONSTRAINT [DF_AreaDataMonth_GameTimeMax] DEFAULT ((0)) NULL,
    [GameTimeMin]          INT           CONSTRAINT [DF_AreaDataMonth_GameTimeMin] DEFAULT ((0)) NULL,
    [GameTimeAvg]          INT           CONSTRAINT [DF_AreaDataMonth_GameTimeAvg] DEFAULT ((0)) NULL,
    [RobotTaxAmount]       BIGINT        DEFAULT ((0)) NOT NULL,
    [TotalConvertUser]     INT           DEFAULT ((0)) NOT NULL,
    [TotalConvertCounts]   INT           DEFAULT ((0)) NOT NULL,
    [TotalOrderCounts]     INT           DEFAULT ((0)) NOT NULL,
    [NewOrderCounts]       INT           DEFAULT ((0)) NOT NULL,
    [NewAgentChargeUser]   INT           CONSTRAINT [DF_AreaDataMonth_NewAgentChargeUser] DEFAULT ((0)) NULL,
    [OldAgentChargeUser]   INT           CONSTRAINT [DF_AreaDataMonth_OldAgentChargeUser] DEFAULT ((0)) NULL,
    [NewAgentChargeAmount] BIGINT        CONSTRAINT [DF_AreaDataMonth_NewAgentChargeAmount] DEFAULT ((0)) NULL,
    [OldAgentChargeAmount] BIGINT        CONSTRAINT [DF_AreaDataMonth_OldAgentChargeAmount] DEFAULT ((0)) NULL,
    [NewConvertUser]       INT           CONSTRAINT [DF_AreaDataMonth_NewConvertUser] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_AreaDataMonth] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_AreaDataMonth_StatTime]
    ON [Stat].[AreaDataMonth]([StatTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AreaDataMonth_AreaID]
    ON [Stat].[AreaDataMonth]([AreaID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道数据统计月报表', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台编号（0表示所有平台的数据）', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldLoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldLoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldLogin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户兑换手续费', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldConvertTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户兑换金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldConvert';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户充值金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'OldCharge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewLoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewLoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewLogin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户兑换手续费', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewConvertTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户兑换金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewConvert';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户充值金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'NewCharge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'LoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'LoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏税收详情', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'GameTaxDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏税收', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'GameTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道编号（0表示所有渠道的数据）', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataMonth', @level2type = N'COLUMN', @level2name = N'AreaID';

