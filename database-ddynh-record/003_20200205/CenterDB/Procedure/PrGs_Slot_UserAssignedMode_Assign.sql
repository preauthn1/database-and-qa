USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_UserAssignedMode_Assign')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Assign] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Louis
-- Create date: 2020/03/04
-- Description:	寫入Slot_UserAssignedMode資料
-- 2020/03/11	Louis	增加判斷是否已存在該筆資料，有則進行修改
-- =============================================

ALTER PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Assign]
	@intUserID			INT,			-- 用户ID
	@intGameID		    INT,			-- GameID
    @intFlagID		    INT,			-- FlagID
    @tinyMode	        TINYINT,		-- 特殊模式 (0: 預設, 1: 放分, 2: 殺分)
    @chvExpireTime		DATETIME,		-- 過期時間
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN
	IF EXISTS( SELECT * FROM [Game].[Slot_UserAssignedMode] WHERE [UserID] = @intUserID AND [GameID] = @intGameID AND [FlagID] = @intFlagID)
	BEGIN
		-- UPDATE the record
		UPDATE [Game].[Slot_UserAssignedMode]
		SET [Mode] = @tinyMode
		,[ExpireTime] = @chvExpireTime
		WHERE [UserID] = @intUserID AND [GameID] = @intGameID AND [FlagID] = @intFlagID
	END
	ELSE
	BEGIN
		-- INSERT the record
		INSERT INTO [Game].[Slot_UserAssignedMode] ([UserID], [GameID], [FlagID], [CreateTime], [Mode] ,[ExpireTime])
		VALUES (@intUserID, @intGameID, @intFlagID, GETDATE(), @tinyMode, @chvExpireTime)
	END
    SET @chvMsg = '新增成功'
    
RETURN 1

END