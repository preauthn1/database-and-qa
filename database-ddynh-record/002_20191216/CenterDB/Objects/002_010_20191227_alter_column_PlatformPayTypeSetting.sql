USE [CenterDB]
GO

ALTER TABLE [Payment].[PlatformPayTypeSetting] ADD Scale INT NOT NULL CONSTRAINT [DF_PlatformPayTypeSetting_Scale] DEFAULT ((100)) WITH VALUES
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'充值比例' , @level0type=N'SCHEMA',@level0name=N'Payment', @level1type=N'TABLE',@level1name=N'PlatformPayTypeSetting', @level2type=N'COLUMN',@level2name=N'Scale'
GO