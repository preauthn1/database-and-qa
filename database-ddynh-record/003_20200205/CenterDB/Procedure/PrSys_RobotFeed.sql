USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrSys_RobotFeed')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrSys_RobotFeed] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  alan
-- Create date: 2018/4/15
-- Description:	機器人加錢
--	2018/05/07	alan	根據區段以及最低金額判斷加錢
--	2018/05/22	alan	#341 機器人金額調整
--  2018/05/28  alan	1.調整作法與金額 2.超過最大金額強制縮減
--	2020/02/19	Louis	調整效能
-- =============================================
ALTER PROCEDURE [dbo].[PrSys_RobotFeed]
AS
BEGIN
	SET NOCOUNT ON

	UPDATE [CenterDB].[Money].[Cash]
	SET [Amount] = D.[UpdateAmount]
	FROM [CenterDB].[Money].[Cash] AS C
	JOIN
	(
		SELECT D.[UserID],D.[Group],D.[Amount],D.[MinAmount],D.[MaxAmount]
		,ROUND(((D.[MaxAmount] - D.[MinAmount] -1) * RAND(CHECKSUM(NEWID())) + D.[MinAmount]), 0) AS [UpdateAmount]
		FROM
		(
			SELECT R.[UserID],R.[Group],C.[Amount]
			,CASE WHEN R.[Group] = 'A' THEN 500000 WHEN R.[Group] = 'B' THEN 1000000 WHEN R.[Group] = 'C' THEN 1000 
			WHEN R.[Group] = 'D' THEN 30000 WHEN R.[Group] = 'E' THEN 8000 ELSE 0 END AS [MinAmount]
			,CASE WHEN R.[Group] = 'A' THEN 1000000 WHEN R.[Group] = 'B' THEN 2000000 WHEN R.[Group] = 'C' THEN 6000 
			WHEN R.[Group] = 'D' THEN 100000 WHEN R.[Group] = 'E' THEN 20000 ELSE 0 END AS [MaxAmount]
			FROM [CenterDB].[Robot].[RobotList] AS R WITH (NOLOCK) 
			JOIN [CenterDB].[Money].[Cash] AS C WITH (NOLOCK) ON R.[UserID] = C.[UserID]
			WHERE R.[ServerID] = 0 AND R.[Group] IN ('A','B','C','D','E')
		) AS D
		WHERE D.[Amount] <= [MinAmount] OR D.[Amount] >= [MaxAmount]
	) AS D ON C.[UserID] = D.[UserID]

END