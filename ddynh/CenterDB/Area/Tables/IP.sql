CREATE TABLE [Area].[IP] (
    [IPmin]    BIGINT        NOT NULL,
    [IPmax]    BIGINT        NOT NULL,
    [AreaName] VARCHAR (174) NOT NULL,
    CONSTRAINT [PK_IP] PRIMARY KEY CLUSTERED ([IPmin] ASC, [IPmax] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP数据库', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'IP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最小IP', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'IP', @level2type = N'COLUMN', @level2name = N'IPmin';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最大IP', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'IP', @level2type = N'COLUMN', @level2name = N'IPmax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'省市名称', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'IP', @level2type = N'COLUMN', @level2name = N'AreaName';

