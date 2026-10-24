USE [CenterDB]
GO
ALTER TABLE [Pay].[OrderList] ADD CoinAmount BIGINT NULL CONSTRAINT [DF_OrderList_CoinAmount]  DEFAULT ((0))