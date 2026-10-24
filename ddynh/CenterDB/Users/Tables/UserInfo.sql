CREATE TABLE [Users].[UserInfo] (
    [UserID]                INT          NOT NULL,
    [LoginName]             VARCHAR (32) NOT NULL,
    [Password]              VARCHAR (32) NOT NULL,
    [BankPassword]          VARCHAR (32) NOT NULL,
    [FaceID]                INT          NOT NULL,
    [NickName]              VARCHAR (32) NOT NULL,
    [Sex]                   TINYINT      NOT NULL,
    [HDType]                TINYINT      NOT NULL,
    [HDCode]                VARCHAR (64) NOT NULL,
    [UserType]              TINYINT      NOT NULL,
    [CreateTime]            DATETIME     NOT NULL,
    [CreateIPAddress]       VARCHAR (15) NOT NULL,
    [LastLogonTime]         DATETIME     NOT NULL,
    [LastLogonIPAddress]    VARCHAR (15) NOT NULL,
    [LastLogonHDType]       TINYINT      NULL,
    [LastLogonHDCode]       VARCHAR (64) NULL,
    [RealName]              VARCHAR (64) NULL,
    [AlipayAccount]         VARCHAR (64) NULL,
    [UnionpayBank]          VARCHAR (5)  NULL,
    [UnionpayAccount]       VARCHAR (64) NULL,
    [UnionpayRealName]      VARCHAR (64) NULL,
    [SumCharge]             BIGINT       CONSTRAINT [DF_UserInfo_SumCharge] DEFAULT ((0)) NOT NULL,
    [SumConvert]            BIGINT       CONSTRAINT [DF_UserInfo_SumConvert] DEFAULT ((0)) NOT NULL,
    [SumConvertTimes]       INT          CONSTRAINT [DF_UserInfo_SumConvertTimes] DEFAULT ((0)) NOT NULL,
    [SumTax]                BIGINT       CONSTRAINT [DF_UserInfo_SumTax] DEFAULT ((0)) NOT NULL,
    [SumLoginTimes]         INT          CONSTRAINT [DF_UserInfo_SumLoginTimes] DEFAULT ((0)) NOT NULL,
    [QuestionCount]         INT          CONSTRAINT [DF_UserInfo_QuestionTimes] DEFAULT ((0)) NOT NULL,
    [GradeID]               INT          CONSTRAINT [DF_UserInfo_GradeID] DEFAULT ((0)) NOT NULL,
    [AreaID]                INT          CONSTRAINT [DF_UserInfo_SiteID] DEFAULT ((1)) NOT NULL,
    [SumAgentCharge]        BIGINT       CONSTRAINT [DF_UserInfo_SumAgentCharge] DEFAULT ((0)) NOT NULL,
    [AdPlan]                INT          CONSTRAINT [DF_UserInfo_AdPlan] DEFAULT ((0)) NOT NULL,
    [AdPlanTime]            DATETIME     NULL,
    [ExperienceCash]        BIGINT       CONSTRAINT [DF_UserInfo_ExperienceCash_1] DEFAULT ((100000)) NULL,
    [SumConvertTax]         BIGINT       CONSTRAINT [DF_UserInfo_SumConvertTax] DEFAULT ((0)) NULL,
    [SumFreeMoney]          BIGINT       CONSTRAINT [DF_UserInfo_SumFreeMoney] DEFAULT ((0)) NULL,
    [SumClubMoney]          BIGINT       CONSTRAINT [DF_UserInfo_SumClubMoney] DEFAULT ((0)) NULL,
    [SumAdminMoney]         BIGINT       CONSTRAINT [DF_UserInfo_SumAdminMoney] DEFAULT ((0)) NULL,
    [SumFlowAmount]         BIGINT       DEFAULT ((0)) NOT NULL,
    [LastConvertFlowAmount] BIGINT       DEFAULT ((0)) NOT NULL
) ON [S_UserID] ([UserID]);






GO
CREATE CLUSTERED INDEX [IUX_UserInfo_UserID]
    ON [Users].[UserInfo]([UserID] ASC, [CreateTime] ASC, [LastLogonTime] ASC, [SumCharge] ASC, [SumConvert] ASC, [GradeID] ASC, [SumAgentCharge] ASC)
    ON [S_UserID] ([UserID]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_UserInfo_LoginName_INCLUDE]
    ON [Users].[UserInfo]([LoginName] ASC)
    INCLUDE([UserID], [FaceID], [NickName], [Sex], [HDType], [HDCode], [UserType], [CreateTime], [CreateIPAddress], [LastLogonTime], [LastLogonIPAddress], [LastLogonHDType], [LastLogonHDCode], [RealName], [AlipayAccount], [UnionpayBank], [UnionpayAccount], [UnionpayRealName], [SumCharge], [SumConvert], [SumConvertTimes], [SumTax], [SumLoginTimes], [QuestionCount], [GradeID], [AreaID], [SumAgentCharge])
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IX_UserInfo_APA_UPA_INCLUDE]
    ON [Users].[UserInfo]([AlipayAccount] ASC, [UnionpayAccount] ASC)
    INCLUDE([UserID], [LoginName], [FaceID], [Sex], [HDType], [HDCode], [UserType], [CreateTime], [CreateIPAddress], [LastLogonTime], [LastLogonIPAddress], [LastLogonHDType], [LastLogonHDCode], [RealName], [SumCharge], [SumConvert], [SumConvertTimes], [SumTax], [SumLoginTimes], [GradeID], [AreaID], [SumAgentCharge])
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IX_UserInfo_HDT_HDC_INCLUDE]
    ON [Users].[UserInfo]([UserType] ASC, [HDCode] ASC, [HDType] ASC)
    INCLUDE([FaceID], [Sex], [UserID], [CreateIPAddress], [LastLogonIPAddress], [AreaID], [LoginName], [NickName])
    ON [PRIMARY];


GO
CREATE NONCLUSTERED INDEX [IX_UserInfo_UID_UT_AID_INCLUDE]
    ON [Users].[UserInfo]([UserID] ASC, [UserType] ASC, [AreaID] ASC)
    INCLUDE([FaceID], [Sex], [HDType], [HDCode], [CreateTime], [CreateIPAddress], [LastLogonTime], [LastLogonIPAddress], [LastLogonHDType], [LastLogonHDCode], [RealName], [AlipayAccount], [UnionpayAccount], [SumCharge], [SumConvert], [SumConvertTimes], [SumTax], [SumLoginTimes], [SumAgentCharge], [LoginName])
    ON [S_UserID] ([UserID]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 普通账号 2 机器人账号 3 快速登录账号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'UserType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户基本信息', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'贡献总税收', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'SumTax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录总数', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'SumLoginTimes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总兑换次数', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'SumConvertTimes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总兑换金额', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'SumConvert';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'充值总额', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'SumCharge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'性别', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'Sex';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'真实姓名', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'RealName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'提问总数', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'QuestionCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录密码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'Password';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'昵称', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'NickName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登陆名称', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'LoginName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登陆时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'LastLogonTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录IP地址', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'LastLogonIPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录硬件类型', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'LastLogonHDType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后登录硬件唯一编码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'LastLogonHDCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'HDType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件唯一编码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'HDCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'等级编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'GradeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'头像编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'FaceID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建IP地址', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'CreateIPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'银行密码', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'BankPassword';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'AreaID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'支付宝账号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'UserInfo', @level2type = N'COLUMN', @level2name = N'AlipayAccount';

