CREATE TABLE [Game].[ForbidIPAddress] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [IPAddress]  VARCHAR (15)  NOT NULL,
    [Memo]       VARCHAR (128) NOT NULL,
    [CreateTime] DATETIME      NOT NULL,
    [ExpireTime] DATETIME      NOT NULL,
    [IPAddress2] VARCHAR (40)  NULL,
    [Min]        BIGINT        NULL,
    [Max]        BIGINT        NULL,
    CONSTRAINT [PK_ForbidIPAddress] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_ForbidIPAddress_IPAddress]
    ON [Game].[ForbidIPAddress]([IPAddress] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'禁用的IP地址', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'过期时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress', @level2type = N'COLUMN', @level2name = N'ExpireTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'ForbidIPAddress', @level2type = N'COLUMN', @level2name = N'CreateTime';

