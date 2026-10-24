CREATE TABLE [Area].[State] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [AreaName] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'省份记录', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'State', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'省份名称', @level0type = N'SCHEMA', @level0name = N'Area', @level1type = N'TABLE', @level1name = N'State', @level2type = N'COLUMN', @level2name = N'AreaName';

