USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_ThirdPartyGame_CreateOrUpdateUserGameLaunchTime')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_ThirdPartyGame_CreateOrUpdateUserGameLaunchTime] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marshall
-- Create date: 2020-02-11
-- Description:	三方遊戲_紀錄首次launch時間
-- =============================================
ALTER PROCEDURE [PrWeb_ThirdPartyGame_CreateOrUpdateUserGameLaunchTime]
	(
		@userID			int,
		@gameID			int
	)
AS
BEGIN	

	DECLARE @existID int;
	
	BEGIN TRAN	

	--先確認資料是否已建過
	SELECT @existID = ID 
	FROM [ThirdParty].[UserGameLaunchSummary] 
	WHERE UserID = @userID AND GameID = @gameID		
	

	IF @existID is NULL 

		BEGIN
		
			--首次launch建立資料
			INSERT INTO [ThirdParty].[UserGameLaunchSummary] ([UserID],[GameID],[CreateTime],[LastLaunchTime],[LaunchTimes])
			VALUES (@userID , @gameID , GETDATE() , GETDATE() , 1)

		END

	ELSE
		BEGIN

			--更新次數、最後時間
			UPDATE [ThirdParty].[UserGameLaunchSummary]
			SET [LastLaunchTime] =  GETDATE() , [LaunchTimes] = [LaunchTimes] + 1
			WHERE UserID = @userID AND GameID = @gameID			

		END


	COMMIT TRAN

END
GO


