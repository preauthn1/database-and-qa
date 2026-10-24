CREATE TABLE [Money].[ConvertRate] (
    [Id]          INT             NOT NULL,
    [MinRang]     BIGINT          NOT NULL,
    [MaxRang]     BIGINT          NOT NULL,
    [ConvertRate] DECIMAL (18, 2) NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'兑换比例配置', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertRate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最小金币数', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertRate', @level2type = N'COLUMN', @level2name = N'MinRang';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最大金币数', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertRate', @level2type = N'COLUMN', @level2name = N'MaxRang';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertRate', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收比例或值,小于1按百分比收取,大于等于1按值收取', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'ConvertRate', @level2type = N'COLUMN', @level2name = N'ConvertRate';

