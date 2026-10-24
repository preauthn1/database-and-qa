-- =============================================
-- Author:		Amy
-- Create date: 2019-08-27
-- Description:	自動新增渠道
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_AutoAddArea]
@intPlatformID INT = 0,
@intAreaID INT = 0,
@charAreaName VARCHAR(50) = NULL,
@intAreaNum INT = 0,
@charReturnMsg VARCHAR(100) = NULL OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

IF @intPlatformID = 0 OR @intAreaID = 0 OR @intAreaNum = 0 OR @charAreaName IS NULL
BEGIN
SET @charReturnMsg = '传入资料值有误'
RETURN 0
END

--先開啟交易
SET XACT_ABORT ON
BEGIN TRANSACTION

--定義變數，這邊用來放值型的T-SQL是否有錯誤
DECLARE @AreaError INT = 0,@GameListError INT = 0 ,@AgentModeConfigError INT = 0 ,@DomainSettingError INT = 0

--定義變數，這邊用來放臨時TABLE的執行數量
DECLARE @AreaRowCount INT = 0,@GameListRowCount INT = 0 ,@AgentModeConfigRowCount INT = 0 ,@DomainSettingRowCount INT = 0

SELECT * INTO #AreaDemoData
FROM [CenterDB].[Area].[Area] 
WHERE PlatformID = @intPlatformid AND AreaID = @intAreaID

SET @AreaRowCount = @@ROWCOUNT

IF(@AreaRowCount = 0)
BEGIN
SET @charReturnMsg = '查无范本渠道，无法自动增加渠道'
RETURN 0
END

DECLARE @intCountNum INT = 1

--取得最後一筆PlatformID = @intPlatformid的AreaID
DECLARE @LastAreaID INT;
SELECT TOP(1)  @LastAreaID = AreaID
FROM [CenterDB].[Area].[Area] 
WHERE PlatformID = @intPlatformid
ORDER BY AreaID DESC

SELECT PlatformID, AreaID, GameID, Sort, Status, Popular, IconID
INTO #GameListData
FROM [CenterDB].Area.GameList
WHERE PlatformID = @intPlatformid AND AreaID = @intAreaID

SET @GameListRowCount = @@ROWCOUNT

SELECT PlatformID, AreaID, Mode1, Mode2, Mode3, Mode4, Mode5, Mode6
INTO #AgentModeConfigData
FROM [Club02].[dbo].[AgentModeConfig]
WHERE PlatformID = @intPlatformid AND AreaID = @intAreaID

SET @AgentModeConfigRowCount = @@ROWCOUNT

SELECT PlatformID, AreaID, Domain, Status, CreateTime, PlatformName
INTO #DomainSettingData
FROM [Club02].[dbo].[DomainSetting]
WHERE PlatformID = @intPlatformid AND AreaID = @intAreaID

SET @DomainSettingRowCount = @@ROWCOUNT

WHILE @intCountNum <= @intAreaNum
BEGIN

DECLARE @charAreaNum VARCHAR(5)
SET @charAreaNum = RIGHT(REPLICATE('0', 3) + CAST(@intCountNum as VARCHAR), 3);
DECLARE @charTempAreaName VARCHAR(30)
SET @charTempAreaName = @charAreaName + @charAreaNum

--新增渠道BEGIN

--將最後一筆AreaID+1作為新的AreaID
SET @LastAreaID = @LastAreaID + 1

UPDATE #AreaDemoData SET AreaID = @LastAreaID, AreaName = @charTempAreaName, Memo = @charAreaName

INSERT [CenterDB].[Area].[Area]
SELECT * FROM #AreaDemoData

IF(@@ERROR > 0)
BEGIN
SET @charReturnMsg = '新增渠道失败，无法自动增加渠道'
--擷取上一次(新增渠道)執行T-SQL的錯誤錯誤代碼
SET @AreaError = @AreaError + @@ERROR
ROLLBACK TRAN
RETURN 0
END

--新增渠道END

--新增渠道的遊戲清單BEGIN

IF(@GameListRowCount > 0)
BEGIN

UPDATE #GameListData SET AreaID = @LastAreaID

INSERT [CenterDB].[Area].[GameList] (PlatformID, AreaID, GameID, Sort, Status, Popular, IconID)
SELECT * FROM #GameListData

IF(@@ERROR > 0)
BEGIN
SET @charReturnMsg = '新增渠道的游戏清单失败，无法自动增加渠道'
--擷取上一次(新增渠道的遊戲清單)執行T-SQL的錯誤錯誤代碼
SET @GameListError = @GameListError + @@ERROR
ROLLBACK TRAN
RETURN 0
END

END
--新增渠道的遊戲清單END

--渠道代理配置BEGIN
IF(@AgentModeConfigRowCount > 0)
BEGIN

UPDATE #AgentModeConfigData SET AreaID = @LastAreaID

INSERT [Club02].[dbo].[AgentModeConfig] (PlatformID, AreaID, Mode1, Mode2, Mode3, Mode4, Mode5, Mode6)
SELECT * FROM #AgentModeConfigData

IF(@@ERROR > 0)
BEGIN
SET @charReturnMsg = '新增渠道代理配置失败，无法自动增加渠道'
--擷取上一次(新增渠道代理配置)執行T-SQL的錯誤錯誤代碼
SET @AgentModeConfigError = @AgentModeConfigError + @@ERROR
ROLLBACK TRAN
RETURN 0
END

END
--渠道代理配置END

--渠道代理域名配置BEGIN
IF(@DomainSettingRowCount > 0)
BEGIN
UPDATE #DomainSettingData SET AreaID = @LastAreaID

INSERT [Club02].[dbo].[DomainSetting] (PlatformID, AreaID, Domain, Status, CreateTime, PlatformName)
SELECT * FROM #DomainSettingData

IF(@@ERROR > 0)
BEGIN
SET @charReturnMsg = '新增渠道代理域名配置失败，无法自动增加渠道'
--擷取上一次(新增渠道代理域名配置)執行T-SQL的錯誤錯誤代碼
SET @DomainSettingError = @DomainSettingError + @@ERROR
ROLLBACK TRAN
RETURN 0
END

END
--渠道代理域名配置END

SET @intCountNum = @intCountNum + 1
--WHILE END
END

DROP TABLE #AreaDemoData
DROP TABLE #GameListData
DROP TABLE #AgentModeConfigData
DROP TABLE #DomainSettingData

IF @AreaError > 0 OR @GameListError > 0 OR @AgentModeConfigError > 0 OR @DomainSettingError > 0
BEGIN
ROLLBACK TRANSACTION
SET @charReturnMsg = '自动增加渠道失败'
RETURN 0
END
COMMIT TRANSACTION

SET @charReturnMsg = '自动增加渠道成功'
RETURN 1

END