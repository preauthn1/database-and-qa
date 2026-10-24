CREATE TABLE [Users].[GradeSetting] (
    [Id]             INT    NOT NULL,
    [Amount]         BIGINT NOT NULL,
    [PromotionAward] INT    CONSTRAINT [DF_GradeSetting_PromotionAward] DEFAULT ((0)) NOT NULL,
    [AvatarFrame]    INT    CONSTRAINT [DF_GradeSetting_AvatarFrame] DEFAULT ((1)) NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户等级配置表', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'GradeSetting';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'等级编号', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'GradeSetting', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'等级限制的贡献税收数量下限', @level0type = N'SCHEMA', @level0name = N'Users', @level1type = N'TABLE', @level1name = N'GradeSetting', @level2type = N'COLUMN', @level2name = N'Amount';

