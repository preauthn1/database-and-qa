CREATE TABLE [Area].[Platform] (
    [PlatformID]              INT           NOT NULL,
    [Name]                    VARCHAR (50)  NOT NULL,
    [UpGradeMsg]              VARCHAR (256) CONSTRAINT [DF_Platform_UpGradeMsg] DEFAULT ('') NOT NULL,
    [AnnMsg]                  VARCHAR (256) CONSTRAINT [DF_Platform_AnnMsg] DEFAULT ('') NOT NULL,
    [FAQContent]              VARCHAR (MAX) NOT NULL,
    [PaySort]                 VARCHAR (512) NOT NULL,
    [UIFlag]                  VARCHAR (32)  NOT NULL,
    [PayTip]                  VARCHAR (256) NOT NULL,
    [PayAmountConfig]         VARCHAR (MAX) NOT NULL,
    [PayStatus]               TINYINT       NOT NULL,
    [PayCloseTip]             VARCHAR (MAX) NOT NULL,
    [GiftMoney]               BIGINT        CONSTRAINT [DF_Platform_GiftMoney] DEFAULT ((0)) NOT NULL,
    [DefaultMoney]            BIGINT        CONSTRAINT [DF_Platform_DefaultMoney] DEFAULT ((0)) NOT NULL,
    [PlatformCreateTime]      DATETIME      CONSTRAINT [DF_Platform_PlatformCreateTime] DEFAULT (getdate()) NULL,
    [UISort]                  VARCHAR (32)  CONSTRAINT [DF_Platform_UISort] DEFAULT ('1,2,3,4') NOT NULL,
    [AnnMsgShow]              TINYINT       CONSTRAINT [DF_Platform_AnnMsgShow] DEFAULT ((0)) NOT NULL,
    [UseDefaultConfig]        BIT           CONSTRAINT [DF_Platform_UseDefaultConfig] DEFAULT ((1)) NOT NULL,
    [ShanFuAccountID]         VARCHAR (20)  NULL,
    [ShanFuSign]              VARCHAR (32)  NULL,
    [ShanFuPayAgentUrl]       VARCHAR (250) NULL,
    [ShanFuPayAgentClientUrl] VARCHAR (250) NULL,
    [Company]                 INT           NULL,
    CONSTRAINT [PK_Platform] PRIMARY KEY CLUSTERED ([PlatformID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'运营平台表', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'升级账号送金币', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'GiftMoney';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'升级提示内容', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'UpGradeMsg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户端UI控制标识,0不显示，1显示 第1位控制IOS充值是否显示(显示IOS充值时,不会显示其它充值方式) 第2位控制在线支付 第3位控制代理支付 第4位控制代理招商 0000', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'UIFlag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值内容提示', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PayTip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值开关 0 关闭 1开启', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PayStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1支付宝 2微信 3银行 4QQ钱包 把需要显示的充值方式按一定顺序配置，如:1,2,4,3', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PaySort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值关闭时的提示信息', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PayCloseTip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值金额配置', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'PayAmountConfig';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台名称', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'常见问题', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'FAQContent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'公告提示内容', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Platform', @level2type = N'COLUMN', @level2name = N'AnnMsg';

