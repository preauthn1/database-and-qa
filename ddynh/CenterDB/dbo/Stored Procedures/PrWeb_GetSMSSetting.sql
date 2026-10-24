
-- =============================================
-- Author:  Mars
-- Create date: 2019/08/28
-- Description:	短信(SMS)設定查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetSMSSetting]
(
	@intAdminID			INT,
	@intPlatformId INT = NULL,
	@intPageIndex INT = 1,
	@intPageSize INT = 50,
	@intPageCount INT = 0 OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	
	--渠道篩選
	DECLARE @Temp_PlatformId TABLE (PlatformId	INT)
	INSERT INTO @Temp_PlatformId Select DISTINCT PlatformId From Area.AreaAdminUser where AdminID = @intAdminID

	SELECT S.SMSSettingId
		    ,S.PlatformId
			,S.SMSId
			,S.SMSInfo
			,S.Sort
			,S.Status
			,S.CreateTime
			,C.Name as SMSName
			,P.Name as PlatformName
	INTO #T
	FROM ServerInfo.SMSSetting AS S
	INNER JOIN ServerInfo.SMSConfig AS C ON C.id = S.SMSId 
	INNER JOIN Area.Platform AS P ON P.PlatformID = S.PlatformId 
	WHERE S.PlatformId in (select PlatformId from @Temp_PlatformId)
		AND @intPlatformId is null or S.PlatformId = @intPlatformId
	ORDER BY S.PlatformId ASC, S.Sort ASC, S.SMSId ASC

	--------------------------------------------------------------------------------
	SELECT	@intPageCount = COUNT(1)
	FROM (
			SELECT * FROM #T WITH (NOLOCK)
	) AS A
	;WITH CTE
	AS (
		SELECT ROW_NUMBER() OVER (ORDER BY A.CreateTime DESC) AS rowNum, *
		FROM (
				SELECT T.* FROM #T AS T
			) AS A
	)
	
	SELECT * FROM CTE WHERE rowNum BETWEEN @intPageSize * (@intPageIndex -1) + 1 AND @intPageSize * @intPageIndex
END