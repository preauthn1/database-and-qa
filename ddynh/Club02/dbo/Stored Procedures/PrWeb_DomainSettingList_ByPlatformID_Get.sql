
-- =============================================
-- Author:		Amy
-- Create date: 2019-07-29
-- Description:	用平台id搜索DomainSetting列表
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_DomainSettingList_ByPlatformID_Get]
@intPlatformID	INT,					--平台ID
@intAdminID		INT,					--後台userID(確認權限使用)
@chvMsg			VARCHAR(250) OUTPUT		--返回消息
AS
BEGIN

--抓取AdminID擁有多少平台權限
CREATE TABLE #temp_table
(PlatformID INT,
PlatformName VARCHAR(30),
AdminID INT
);

INSERT INTO #temp_table EXEC [dbo].[PrWeb_UserAgent_GetPlatformInfo] @intAdminID

--join #temp_table 確認此AdminID可以讀取下列DomainSetting列表
SELECT a.[ID],a.[PlatformID],a.[AreaID],a.[Domain],a.[Status],a.[CreateTime],a.[PlatformName], b.AdminID FROM [Club02].[dbo].[DomainSetting] AS a WITH(NOLOCK)
inner join #temp_table AS b WITH(NOLOCK) ON a.PlatformID = b.PlatformID
WHERE (@intPlatformID = 0 OR a.[PlatformID] = @intPlatformID)
ORDER BY CreateTime

DROP TABLE #temp_table

SET @chvMsg	= '操作成功'
RETURN 1
END