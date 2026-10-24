USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_UserAssignedMode_Delete')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Delete] AS BEGIN RETURN END'
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
-- Description:	刪除Slot_UserAssignedMode指定紀錄
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Delete]
	@intUserID			INT,			-- 用户ID
	@intGameID		    INT,			-- GameID
    @intFlagID		    INT,			-- FlagID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN
    -- Return Data From Slot_UserAssignedMode

	DELETE [Game].[Slot_UserAssignedMode]
	WHERE [UserID] = @intUserID AND [GameID] = @intGameID AND [FlagID] = @intFlagID

	SET @chvMsg = '操作成功'
	RETURN 1

END