-- =============================================
-- Author:  Mars
-- Create date: 2019/10/03
-- Description:	查询用户銀行记录依類型加總
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetBankLogGroupBySourceType]
(
	@intAdminID			INT,
	@intUserID			INT = NULL	
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @Temp_GetBankLogGroupBySourceType TABLE
		(
			[SourceTypeID] INT,
			[UpdateAmount] INT,
			[PlatformID] INT,
			[AreaID] INT
		)

	--渠道篩選
	/*  取資料暫存  */
	INSERT INTO @Temp_GetBankLogGroupBySourceType
	EXEC [LogDB].[dbo].[PrWeb_Stat_GetBankLogGroupBySourceType]
		@intUserID = @intUserID

	/*  回傳資料  */
	SELECT	A.SourceTypeID,
			A.UpdateAmount
	FROM @Temp_GetBankLogGroupBySourceType AS A
	where A.AreaID in (select areaid from dbo.Fn_GetAdminAccessRights(@intAdminID))
END