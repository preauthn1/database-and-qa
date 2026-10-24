CREATE TABLE [Warning].[WarningStatus] (
    [UserID]        INT     NOT NULL,
    [WarningStatus] TINYINT NOT NULL,
    CONSTRAINT [PK_WarningStatus] PRIMARY KEY CLUSTERED ([UserID] ASC) WITH (FILLFACTOR = 80)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台帐号 报警提示', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台账号是否提示报警', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningStatus', @level2type = N'COLUMN', @level2name = N'WarningStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'WarningStatus', @level2type = N'COLUMN', @level2name = N'UserID';

