-- =============================================
-- Author:  jason
-- Create date: 2019/04/13
-- Description: 全民代理后台 查询一级下线比例
-- 2019-07-30 AMY 重寫 全民代理后台 查询一级下线比例(最後一級取資料庫最大值)
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UserAgent_UserRate_Get]
(
--@intUserID		INT,				--用户 ID
@intSubUserID	int,				--调整用户 ID
@chvMsg			VARCHAR(250)	OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON

	----取得最大的Stage1,Stage2,Stage3
	DECLARE @intBiggestSystemStage1 INT;
	DECLARE @intBiggestSystemStage2 INT;
	DECLARE @intBiggestSystemStage3 INT;
	SELECT @intBiggestSystemStage1 = [Stage1], @intBiggestSystemStage2 = [Stage2], @intBiggestSystemStage3 = [Stage3] FROM [dbo].[UserAgentSystemLevelRate] WHERE [Level] = 6

	----取得@intUserID的UserAgentUserRate ， 並join UserAgentSystemLevelRate 將下一級的比例上限寫入 SystemStage1,SystemStage2,SystemStage3
	SELECT	a.[UserID],
		a.[UserLevel],
		a.[Stage1],
		a.[Stage2],
		a.[Stage3],
		b.[Stage1] AS SystemStage1, 
		b.[Stage2] AS SystemStage2, 
		b.[Stage3] AS SystemStage3
	INTO #tempTable
	FROM [dbo].[UserAgentUserRate]  AS a WITH (NOLOCK)
	FULL JOIN [dbo].[UserAgentSystemLevelRate] AS b WITH (NOLOCK)
	ON a.UserLevel = (b.Level - 1)
	WHERE userid = @intSubUserID

	----Levle6 的 SystemStage1,SystemStage2,SystemStage3 複寫 UserAgentSystemLevelRate 的 Level6 比例
	UPDATE #tempTable
	SET	SystemStage1 = @intBiggestSystemStage1, SystemStage2 = @intBiggestSystemStage2, SystemStage3 = @intBiggestSystemStage3
	WHERE [UserLevel] = 6;

	----查詢後刪除#tempTable
	SELECT * FROM #tempTable
	DROP TABLE #tempTable;

	SET @chvMsg	= '操作完成'
	RETURN 1
END







