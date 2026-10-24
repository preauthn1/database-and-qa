CREATE TABLE [Robot].[ServerConfig] (
    [Id]          INT      IDENTITY (1, 1) NOT NULL,
    [ServerID]    INT      NOT NULL,
    [BeginTime]   CHAR (5) NOT NULL,
    [EndTime]     CHAR (5) NOT NULL,
    [MinCount]    INT      NOT NULL,
    [MaxCount]    INT      NOT NULL,
    [MinLevel]    INT      NOT NULL,
    [MaxLevel]    INT      NOT NULL,
    [StartMinute] INT      NULL,
    [EndMinute]   INT      NULL,
    [Status]      TINYINT  NULL,
    CONSTRAINT [PK_ServerConfig] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ServerConfig_ServerID]
    ON [Robot].[ServerConfig]([ServerID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人服务器配置', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最小智商等级', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'MinLevel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最小数量', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'MinCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最大智商等级', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'MaxLevel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最大数量', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'MaxCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'结束时间', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'EndTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'开始时间', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'ServerConfig', @level2type = N'COLUMN', @level2name = N'BeginTime';

