CREATE TABLE [ServerInfo].[PlazaServerList] (
    [ServerID]       INT          NOT NULL,
    [ClientAddr]     VARCHAR (32) NOT NULL,
    [NotifyAddr]     VARCHAR (32) NOT NULL,
    [HttpAddr]       VARCHAR (32) NULL,
    [LastUpdateTime] DATETIME     NOT NULL,
    CONSTRAINT [PK_PlazaServerList] PRIMARY KEY CLUSTERED ([ServerID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'广场服务器', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'PlazaServerList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'PlazaServerList', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'通知地址', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'PlazaServerList', @level2type = N'COLUMN', @level2name = N'NotifyAddr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后更新时间', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'PlazaServerList', @level2type = N'COLUMN', @level2name = N'LastUpdateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户端访问地址', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'PlazaServerList', @level2type = N'COLUMN', @level2name = N'ClientAddr';

