USE [CenterDB]
GO

ALTER TABLE [Game].[SuperTool_JLBPK_SystemPoolWinLost] ADD GameRound INT NOT NULL CONSTRAINT [DF_SuperTool_JLBPK_SystemPoolWinLost_GameRound] DEFAULT ((0)) WITH VALUES
GO
