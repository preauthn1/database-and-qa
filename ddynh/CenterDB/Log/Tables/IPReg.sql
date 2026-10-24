CREATE TABLE [Log].[IPReg] (
    [IPAddress] VARCHAR (15) NOT NULL,
    [RegCount]  INT          NOT NULL,
    [LogDate]   INT          NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_IPReg_IP]
    ON [Log].[IPReg]([IPAddress] ASC, [LogDate] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址注册记录', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'IPReg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'注册次数', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'IPReg', @level2type = N'COLUMN', @level2name = N'RegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'IPReg', @level2type = N'COLUMN', @level2name = N'IPAddress';

