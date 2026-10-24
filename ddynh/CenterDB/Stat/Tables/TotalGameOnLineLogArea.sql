CREATE TABLE [Stat].[TotalGameOnLineLogArea] (
    [Id]           INT      IDENTITY (1, 1) NOT NULL,
    [AreaID]       INT      NOT NULL,
    [TotalCount]   INT      NOT NULL,
    [PCCount]      INT      NOT NULL,
    [IOSCount]     INT      NOT NULL,
    [AndroidCount] INT      NOT NULL,
    [StatTime]     DATETIME NOT NULL,
    CONSTRAINT [PK_TotalGameOnLineLogArea_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);




GO
CREATE CLUSTERED INDEX [IX_TotalGameOnLineLogArea_StatTime]
    ON [Stat].[TotalGameOnLineLogArea]([StatTime] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道在线人数统计表', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'总在线数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'TotalCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'统计日期', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'StatTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PC端人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'PCCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IOS人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'IOSCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录ID', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'渠道ID', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'AreaID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Android人数', @level0type = N'SCHEMA', @level0name = N'Stat', @level1type = N'TABLE', @level1name = N'TotalGameOnLineLogArea', @level2type = N'COLUMN', @level2name = N'AndroidCount';

