CREATE TABLE [Area].[Area] (
    [AreaID]                      INT            NOT NULL,
    [AreaName]                    VARCHAR (32)   NOT NULL,
    [ClientPlatform]              VARCHAR (32)   NOT NULL,
    [PlatformID]                  INT            NOT NULL,
    [Memo]                        VARCHAR (256)  NOT NULL,
    [AdminID]                     INT            NOT NULL,
    [Sort]                        INT            NOT NULL,
    [ShareURL]                    VARCHAR (500)  NOT NULL,
    [ShowConvertLimit]            BIGINT         CONSTRAINT [DF_Area_ShowConvertLimit] DEFAULT ((0)) NOT NULL,
    [ShowAllGameLimit]            BIGINT         CONSTRAINT [DF_Area_ShowAllGameLimit] DEFAULT ((0)) NOT NULL,
    [ShowVIPAgent]                BIGINT         CONSTRAINT [DF_Area_ShowVIPAgent] DEFAULT ((0)) NOT NULL,
    [ShowCS]                      BIGINT         CONSTRAINT [DF_Area_ShowCS] DEFAULT ((0)) NOT NULL,
    [ShowConvertBindPhone]        TINYINT        CONSTRAINT [DF_Area_ShowConvertBindPhone] DEFAULT ((0)) NOT NULL,
    [ShowAllGameBindPhone]        TINYINT        CONSTRAINT [DF_Area_ShowAllGameBindPhone] DEFAULT ((0)) NOT NULL,
    [ShowVIPAgentBindPhone]       TINYINT        CONSTRAINT [DF_Area_ShowVIPAgentBindPhone] DEFAULT ((0)) NOT NULL,
    [ShowCSBindPhone]             TINYINT        CONSTRAINT [DF_Area_ShowCSBindPhone] DEFAULT ((0)) NOT NULL,
    [PlaytimeCS]                  INT            CONSTRAINT [DF_Area_PlaytimeCS] DEFAULT ((0)) NOT NULL,
    [PlaytimeConvert]             INT            CONSTRAINT [DF_Area_PlaytimeConvert] DEFAULT ((0)) NOT NULL,
    [PlaytimeVIPAgent]            INT            CONSTRAINT [DF_Area_PlaytimeVIPAgent] DEFAULT ((0)) NOT NULL,
    [CreateTime]                  DATETIME       CONSTRAINT [DF_Area_CreateTime] DEFAULT (getdate()) NOT NULL,
    [AreaStatus]                  BIT            CONSTRAINT [DF_Area_AreaStatus] DEFAULT ((1)) NOT NULL,
    [FAQContent]                  VARCHAR (3000) NULL,
    [PayTips]                     VARCHAR (256)  NULL,
    [UpGradeMsg]                  VARCHAR (256)  NULL,
    [AnnMsg]                      VARCHAR (256)  NULL,
    [AnnMsgShow]                  TINYINT        NULL,
    [SetDefault]                  TINYINT        NULL,
    [AreaConfig]                  VARCHAR (5000) NULL,
    [GiftMoney]                   BIGINT         NOT NULL,
    [GiftMoneyFlowLimit]          BIGINT         CONSTRAINT [DF_Area_GiftMoneyFlowLimit] DEFAULT ((0)) NOT NULL,
    [DefaultMoney]                BIGINT         NOT NULL,
    [DefaultMoneyFlowLimit]       BIGINT         CONSTRAINT [DF_Area_DefaultMoneyFlowLimit] DEFAULT ((0)) NOT NULL,
    [ShopNameID]                  TINYINT        CONSTRAINT [DF_Area_ShopNameID] DEFAULT ((1)) NOT NULL,
    [AgentNameID]                 TINYINT        CONSTRAINT [DF_Area_AgentNameID] DEFAULT ((1)) NOT NULL,
    [ShowConvertPopup]            TINYINT        CONSTRAINT [DF_Area_ShowConvertPopup] DEFAULT ((0)) NOT NULL,
    [ConvertPopupText]            VARCHAR (256)  CONSTRAINT [DF_Area_ConvertPopupText] DEFAULT ('') NULL,
    [IsGameCategoryFilterVisible] BIT            DEFAULT ((0)) NOT NULL
);












GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换未达成强制显示', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'ShowConvertPopup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换禁止提示文本', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'ConvertPopupText';


GO
CREATE NONCLUSTERED INDEX [IX_Area_PlatformID]
    ON [Area].[Area]([PlatformID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Area_AreaID]
    ON [Area].[Area]([AreaID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'綁定帳號流水', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'GiftMoneyFlowLimit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'註冊預設金幣流水', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'DefaultMoneyFlowLimit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道信息', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序值', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备注', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户端平台类型(Android,IOS)', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'ClientPlatform';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道名称', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'AreaName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'AreaID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道所属管理员ID', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'Area', @level2type = N'COLUMN', @level2name = N'AdminID';

