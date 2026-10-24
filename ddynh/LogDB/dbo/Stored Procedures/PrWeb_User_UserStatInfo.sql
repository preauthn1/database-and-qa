-- =============================================
-- Author:  Jason
-- Create date: 2018/04/09
-- Description:	統計分析-用戶統計-用戶統計信息查詢
-- 2019/08/07	amy	增加@intAdminID、@intPlatformID、@intAreaID，可限制權限及使用平台或渠道ID查詢
-- 2019/08/22	amy	調整限制權限及使用平台或渠道ID查詢來源
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_User_UserStatInfo]
	@tnySearchType		TINYINT,		--查询类型 1同IP注册数 2 同IP登录数 3同Mac注册数 4同Mac登录数
	@intCount			INT,			--数量
	@intAdminID INT = 1,				--登入者AdminID
	@intPlatformID	INT = NULL,
	@intAreaID		INT = NULL
AS
BEGIN

DECLARE @GetPlatformAreaByAdminUserTempTable TABLE(AdminID INT, PlatformID INT, AreaID INT)

INSERT INTO @GetPlatformAreaByAdminUserTempTable
SELECT @intAdminID AS AdminID, PlatformID, AreaID
FROM [CenterDB].[dbo].Fn_GetAdminAccessRights(@intAdminID)

-- @tnySearchType = 1 or 3 會用到這張表查詢
IF (@tnySearchType = 1) OR (@tnySearchType = 3)
BEGIN

SELECT *
INTO #UserRegLogTempTable
FROM [LogDB].[Users].[UserRegLog] WITH (NOLOCK)
WHERE AreaID = ISNULL(@intAreaID, AreaID)
AND AreaID IN (SELECT AreaID FROM @GetPlatformAreaByAdminUserTempTable)
AND PlatformID = ISNULL(@intPlatformID, PlatformID)
AND PlatformID IN (SELECT PlatformID FROM @GetPlatformAreaByAdminUserTempTable)

END

ELSE
-- @tnySearchType = 2 or 4 會用到這張表查詢
BEGIN

SELECT * INTO #UserLogonLogTempTable
FROM [LogDB].[Users].[UserLogonLog] WITH (NOLOCK)
WHERE AreaID = ISNULL(@intAreaID, AreaID)
AND AreaID IN (SELECT AreaID FROM @GetPlatformAreaByAdminUserTempTable)
AND PlatformID = ISNULL(@intPlatformID, PlatformID)
AND PlatformID IN (SELECT PlatformID FROM @GetPlatformAreaByAdminUserTempTable)

END

IF @tnySearchType = 1
	BEGIN

		SELECT [IPAddress] as Info,COUNT(1) as Amount
		FROM #UserRegLogTempTable WITH (NOLOCK)
		GROUP BY [IPAddress]
		HAVING COUNT(1)>@intCount
		ORDER By Amount DESC

	END
	ELSE IF @tnySearchType = 2
	BEGIN
		SELECT [IPAddress] AS Info,COUNT(1) as Amount
		FROM #UserLogonLogTempTable WITH (NOLOCK)
		GROUP BY [IPAddress]
		HAVING COUNT(1) > @intCount
		ORDER By Amount DESC
	END
	ELSE IF @tnySearchType = 3
	BEGIN
		SELECT HDCode as Info,COUNT(1) as Amount
		FROM #UserRegLogTempTable WITH (NOLOCK)
		GROUP BY HDCode
		HAVING COUNT(1)>@intCount
		ORDER By Amount DESC
	END
	ELSE IF @tnySearchType = 4
	BEGIN
		SELECT [HDCode] AS Info,COUNT(1) as Amount
		FROM #UserLogonLogTempTable WITH (NOLOCK)
		GROUP BY [HDCode]
		HAVING COUNT(1) > @intCount
		ORDER By Amount DESC
	END

IF (@tnySearchType = 1) OR (@tnySearchType = 3)
DROP TABLE #UserRegLogTempTable
ELSE
DROP TABLE #UserLogonLogTempTable

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_User_UserStatInfo] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_User_UserStatInfo] TO [xbuser]
    AS [dbo];

