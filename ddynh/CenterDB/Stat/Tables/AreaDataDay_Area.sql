CREATE TABLE [Stat].[AreaDataDay_Area] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [StatTime]           DATETIME      NOT NULL,
    [PlatformID]         INT           NOT NULL,
    [AreaID]             INT           NOT NULL,
    [GameID]             INT           NULL,
    [ServerID]           INT           NULL,
    [OldLogin]           BIGINT        NOT NULL,
    [NewLogin]           BIGINT        NOT NULL,
    [OldCharge]          BIGINT        NOT NULL,
    [NewCharge]          BIGINT        NOT NULL,
    [OldConvert]         BIGINT        NOT NULL,
    [NewConvert]         BIGINT        NOT NULL,
    [OldConvertTax]      BIGINT        NOT NULL,
    [NewConvertTax]      BIGINT        NOT NULL,
    [LoginIP]            BIGINT        NOT NULL,
    [OldLoginIP]         BIGINT        NOT NULL,
    [NewLoginIP]         BIGINT        NOT NULL,
    [LoginMac]           BIGINT        NOT NULL,
    [OldLoginMac]        BIGINT        NOT NULL,
    [NewLoginMac]        BIGINT        NOT NULL,
    [GameTax]            BIGINT        NOT NULL,
    [GameTaxDetail]      VARCHAR (MAX) NOT NULL,
    [Total_OrderUser]    BIGINT        NULL,
    [NewOrderUser]       BIGINT        NULL,
    [iOSCount]           INT           NULL,
    [NewiOSCount]        INT           NULL,
    [AndRoidCount]       INT           NULL,
    [NewAndRoidCount]    INT           NULL,
    [PCCount]            INT           NULL,
    [NewPCCount]         INT           NULL,
    [AmountTotal]        BIGINT        NULL,
    [NewAmountTotal]     BIGINT        NULL,
    [AmountAvg]          BIGINT        NULL,
    [NewAmountAvg]       BIGINT        NULL,
    [TaxAmountTotal]     BIGINT        NULL,
    [NewTaxAmountTotal]  BIGINT        NULL,
    [TaxAmountAvg]       BIGINT        NULL,
    [NewTaxAmountAvg]    BIGINT        NULL,
    [GameTimeMax]        INT           NULL,
    [GameTimeMin]        INT           NULL,
    [GameTimeAvg]        INT           NULL,
    [RobotTaxAmount]     BIGINT        DEFAULT ((0)) NOT NULL,
    [TotalConvertUser]   INT           DEFAULT ((0)) NOT NULL,
    [TotalConvertCounts] INT           DEFAULT ((0)) NOT NULL,
    [TotalOrderCounts]   INT           DEFAULT ((0)) NOT NULL,
    [NewOrderCounts]     INT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AreaDataDay_Area] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_DayAreaDataStat_Area_AreaID]
    ON [Stat].[AreaDataDay_Area]([AreaID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AreaDataStatDay_Area_StatTime]
    ON [Stat].[AreaDataDay_Area]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道日报表统计数据', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计时间', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台编号（0表示所有平台的数据）', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldLoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldLoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户登录数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldLogin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户兑换手续费', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldConvertTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户兑换金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldConvert';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'老用户充值金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'OldCharge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewLoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewLoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户登录数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewLogin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户兑换手续费', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewConvertTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户兑换金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewConvert';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新用户充值金额', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'NewCharge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录Mac总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'LoginMac';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录IP总数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'LoginIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏税收详情', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'GameTaxDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏税收', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'GameTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道编号（0表示所有渠道的数据）', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'AreaDataDay_Area', @level2type = N'COLUMN', @level2name = N'AreaID';

