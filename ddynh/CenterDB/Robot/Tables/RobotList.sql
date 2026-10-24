CREATE TABLE [Robot].[RobotList] (
    [UserID]   INT      NOT NULL,
    [ServerID] INT      NOT NULL,
    [LevelID]  INT      NOT NULL,
    [Group]    CHAR (1) CONSTRAINT [DF_RobotList_Group] DEFAULT ('') NOT NULL,
    [Sort]     INT      CONSTRAINT [DF_RobotList_Sort] DEFAULT (abs(checksum(newid()))) NOT NULL,
    CONSTRAINT [PK_RobotList] PRIMARY KEY CLUSTERED ([UserID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IDX_RobotList_ServerID_LevelID]
    ON [Robot].[RobotList]([ServerID] ASC, [LevelID] ASC)
    INCLUDE([UserID], [Sort]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人列表', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotList';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人用户编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotList', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'服务器编号', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotList', @level2type = N'COLUMN', @level2name = N'ServerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'智商等级', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotList', @level2type = N'COLUMN', @level2name = N'LevelID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'机器人分群', @level0type = N'SCHEMA', @level0name = N'Robot', @level1type = N'TABLE', @level1name = N'RobotList', @level2type = N'COLUMN', @level2name = N'Group';

