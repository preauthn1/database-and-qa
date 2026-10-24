CREATE TABLE [Game].[GameMessage] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [PlatformID]   INT           CONSTRAINT [DF_GameMessage_PlatformID] DEFAULT ((1)) NOT NULL,
    [MsgContent]   VARCHAR (512) NOT NULL,
    [BeginTime]    DATETIME      NOT NULL,
    [EndTime]      DATETIME      NOT NULL,
    [Interval]     INT           NOT NULL,
    [Status]       TINYINT       NOT NULL,
    [LastSendTime] DATETIME      NULL,
    [AllPlatform]  TINYINT       CONSTRAINT [DF_GameMessage_AllPlatform_1] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_GameMessage] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏消息', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'状态', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'所属平台ID', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'消息内容', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'MsgContent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后发送时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'LastSendTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'频率，单位秒', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'Interval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'结束时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'EndTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'开始时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'GameMessage', @level2type = N'COLUMN', @level2name = N'BeginTime';

