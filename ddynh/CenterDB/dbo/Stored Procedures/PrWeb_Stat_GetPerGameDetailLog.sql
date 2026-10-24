
-- =============================================
-- Author:  Mars
-- Create date: 2019/10/31
-- Description:	流水報表
--	2019/10/31	Mars		新增流水報表 #206
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetPerGameDetailLog]
(
	@intAdminID			INT,			--使用者ID
	@intUserID			INT = NULL,		--用户ID
	@intGameID			INT = NULL,		--遊戲ID
	@intPlatformID		INT = NULL,		--平台ID
	@intAreaID			INT = NULL,		--渠道ID
	@dtStatTime			DATETIME = NULL,
	@dtEndTime			DATETIME = NULL,
	@intPageIndex		INT = 1,
	@intPageSize		INT = 20,
	@intPageCount		INT = 0		OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	EXEC [LogDB].[dbo].[PrPs_Stat_GetPerGameDetailLog]
		@intAdminID		= @intAdminID,
		@intUserID		= @intUserID,		--用户ID
		@intGameID		= @intGameID,		--遊戲ID
		@intPlatformID	= @intPlatformID,	--平台ID
		@intAreaID		= @intAreaID,		--渠道ID
		@dtStatTime		= @dtStatTime,
		@dtEndTime		= @dtEndTime,
		@intPageIndex	= @intPageIndex,
		@intPageSize	= @intPageSize,
		@intPageCount	= @intPageCount OUTPUT
END