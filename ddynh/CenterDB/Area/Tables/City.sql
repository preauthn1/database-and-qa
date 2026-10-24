CREATE TABLE [Area].[City] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [AreaName] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'城市数据库', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'City', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'城市名称', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'City', @level2type = N'COLUMN', @level2name = N'AreaName';

