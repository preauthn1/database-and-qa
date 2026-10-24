CREATE TABLE [Event].[PromotionEventAreaMapping] (
    [MappingID] INT IDENTITY (1, 1) NOT NULL,
    [EventID]   INT NOT NULL,
    [AreaID]    INT NOT NULL,
    CONSTRAINT [PK_PromotionEventAreaMappingEntity] PRIMARY KEY CLUSTERED ([MappingID] ASC)
);

