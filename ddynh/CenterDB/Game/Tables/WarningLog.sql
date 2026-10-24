CREATE TABLE [Game].[WarningLog] (
    [LogID]     INT           IDENTITY (1, 1) NOT NULL,
    [Memo]      VARCHAR (MAX) NOT NULL,
    [WriteTime] DATETIME      NOT NULL,
    CONSTRAINT [PK_WarningLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏警告记录', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WarningLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'写入时间', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'WriteTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'WarningLog', @level2type = N'COLUMN', @level2name = N'LogID';

