USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_Slot_UserAssignedMode_Read')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Read] AS BEGIN RETURN END'
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
-- Description:	讀取Slot_UserAssignedMode 資料
-- =============================================

ALTER PROCEDURE [dbo].[PrGs_Slot_UserAssignedMode_Read]
	@intUserID			INT,			-- 用户ID
	@intGameID		    INT,			-- GameID
    @intFlagID		    INT,			-- FlagID
	@chvMsg				VARCHAR(100)	OUTPUT
AS
BEGIN
    -- Return Data From Slot_UserAssignedMode
    SELECT 
		[UserID],
		[GameID],
		[FlagID],
		[CreateTime],
		[Mode],
		[ExpireTime]
    FROM
        [Game].[Slot_UserAssignedMode]
    WHERE
        [UserID] = @intUserID
        AND
        [GameID] = @intGameID
        AND
        [FlagID] = @intFlagID

	ORDER BY ID
	SET @chvMsg = '操作成功'
	RETURN 1

END