CREATE TABLE [ServerInfo].[GameServerList] (
    [ServerID]       INT          NOT NULL,
    [GameID]         INT          NOT NULL,
    [ServerName]     VARCHAR (64) NOT NULL,
    [ShowName]       VARCHAR (64) NOT NULL,
    [ClientAddr]     VARCHAR (32) NULL,
    [NotifyAddr]     VARCHAR (32) NULL,
    [HttpAddr]       VARCHAR (32) NULL,
    [Money]          BIGINT       NOT NULL,
    [LastUpdateTime] DATETIME     NOT NULL,
    CONSTRAINT [PK_GameServerList] PRIMARY KEY CLUSTERED ([ServerID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_GameServerList_GameID_ServerName]
    ON [ServerInfo].[GameServerList]([GameID] ASC, [ServerName] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏服务器列表', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'显示名称', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'ShowName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器名称', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'ServerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'通知地址', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'NotifyAddr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'入场金币数', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'Money';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后更新时间', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'LastUpdateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏编号', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'GameID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'客户端访问地址', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'GameServerList', @level2type = N'COLUMN', @level2name = N'ClientAddr';

