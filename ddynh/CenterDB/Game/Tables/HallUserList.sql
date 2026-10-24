CREATE TABLE [Game].[HallUserList] (
    [UserID]     INT      NOT NULL,
    [ServerID]   SMALLINT NOT NULL,
    [HDType]     TINYINT  NOT NULL,
    [CreateTime] DATETIME DEFAULT (getdate()) NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'大厅在线玩家', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'HallUserList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'HallUserList', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'HallUserList', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'HallUserList', @level2type = N'COLUMN', @level2name = N'HDType';

