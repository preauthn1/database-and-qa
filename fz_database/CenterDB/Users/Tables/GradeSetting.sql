CREATE TABLE [Users].[GradeSetting] (
    [Id]             INT    NOT NULL,
    [Amount]         BIGINT NOT NULL,
    [PromotionAward] INT    DEFAULT ((0)) NULL,
    [AvatarFrame]    INT    DEFAULT ((1)) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户等级配置表', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'GradeSetting';

