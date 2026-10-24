CREATE TABLE [Log].[HDReg] (
    [HDType]     TINYINT      NOT NULL,
    [HDCode]     VARCHAR (64) NOT NULL,
    [RegCount]   INT          NOT NULL,
    [LogDate]    INT          NOT NULL,
    [CreateTime] DATETIME     CONSTRAINT [DF_HDReg_CreateTime] DEFAULT (getdate()) NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_HDReg]
    ON [Log].[HDReg]([HDCode] ASC, [LogDate] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件注册记录', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'HDReg';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'注册次数', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'HDReg', @level2type = N'COLUMN', @level2name = N'RegCount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件类型', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'HDReg', @level2type = N'COLUMN', @level2name = N'HDType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'硬件唯一编码', @level0type = N'SCHEMA', @level0name = N'Log', @level1type = N'TABLE', @level1name = N'HDReg', @level2type = N'COLUMN', @level2name = N'HDCode';

