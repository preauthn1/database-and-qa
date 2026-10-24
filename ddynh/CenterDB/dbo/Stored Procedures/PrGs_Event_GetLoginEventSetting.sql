-- =============================================
-- Author:		Marshall
-- Create date: 2019-10-21
-- Description:	取得七日登入活動、每日贈送金額設定

-- 2019-11-01		Marshall		增加hardCode判斷，根據平台號不同。寫死不同登入7天金幣
-- 2019-11-06		Marshall		佰坊編號已確定
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Event_GetLoginEventSetting]
	@intUserID int
AS
BEGIN	

	Create Table #Temp
	(
		Day int,
		BonusAmount bigint,		
		FlowAmount bigint,
	)
	
	
	DECLARE @areaID int;
	DECLARE @platformID int;
	DECLARE @eventSettingID int;

	SET @areaID = (SELECT TOP 1 AreaID FROM Users.UserInfo WHERE UserID = @intUserID)
	SET @platformID = (SELECT TOP 1 PlatformID FROM Area.Area WHERE AreaID = @areaID )
	SET @eventSettingID = (SELECT TOP 1 Id FROM Users.EventSetting WHERE PlatformID = @platformID AND Status = 1 AND EventType = 1)
	

	--有設置
	IF (@eventSettingID > 0)

		BEGIN		

			INSERT INTO #Temp
			SELECT [Sequence] ,  [Value] , [Value]* FlowRate 
			FROM Event.EvnetSettingBonus
			WHERE EventSettingID = @eventSettingID
			ORDER BY [Sequence]

		END

	ELSE
		BEGIN
		
			-- 沒開啟，全部回0
			INSERT INTO #Temp VALUES(1, 0 , 0*8)
			INSERT INTO #Temp VALUES(2, 0 , 0*8)
			INSERT INTO #Temp VALUES(3, 0 , 0*8)
			INSERT INTO #Temp VALUES(4, 0 , 0*8)
			INSERT INTO #Temp VALUES(5, 0 , 0*8)
			INSERT INTO #Temp VALUES(6, 0 , 0*8)
			INSERT INTO #Temp VALUES(7, 0 , 0*8)

		END


	SELECT * FROM #Temp

	DROP TABLE #Temp

END