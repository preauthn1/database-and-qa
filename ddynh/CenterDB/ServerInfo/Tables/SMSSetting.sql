CREATE TABLE [ServerInfo].[SMSSetting] (
    [SMSSettingId]   INT            IDENTITY (1, 1) NOT NULL,
    [PlatformId]     INT            CONSTRAINT [DF_SMSSetting_PlatformId] DEFAULT ((0)) NOT NULL,
    [SMSId]          INT            CONSTRAINT [DF_SMSSetting_SMSId] DEFAULT ((0)) NOT NULL,
    [SMSInfo]        NVARCHAR (MAX) NULL,
    [Sort]           TINYINT        CONSTRAINT [DF_SMSSetting_Sort] DEFAULT ((0)) NOT NULL,
    [Status]         TINYINT        CONSTRAINT [DF_SMSSetting_Status] DEFAULT ((0)) NOT NULL,
    [CreateTime]     DATETIME       CONSTRAINT [DF_SMSSetting_CreateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdateTime] DATETIME       CONSTRAINT [DF_SMSSetting_LastUpdateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SMSSetting] PRIMARY KEY CLUSTERED ([SMSSettingId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最後更新時間', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'LastUpdateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'新增時間', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'CreateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'權重(越大越優先)', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'Sort';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'訊息商設定', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'SMSInfo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SMS訊息商ID', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'SMSId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'平台ID', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'SMSSetting', @level2type = N'COLUMN', @level2name = N'PlatformId';

