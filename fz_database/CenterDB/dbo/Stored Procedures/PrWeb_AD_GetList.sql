


-- =============================================
-- Author: alan
-- Create date: 2018/07/12
-- Description: 取得廣告清單
-- Change:
--	2018/11/29	alan 增加areaid 參數
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_AD_GetList]
@intPlatformID INT = null,
@intAreaID INT = null
AS
BEGIN
	Select Id,PlatformID,AreaID,Picture,Link,Behavior,Status,CreateTime from [Area].[Advertisement] with (nolock) 
	Where 
	PlatformID = ISNULL(@intPlatformID,PlatformID)
	and AreaID = ISNULL(@intAreaID,AreaID)
	ORDER BY PlatformID
END

