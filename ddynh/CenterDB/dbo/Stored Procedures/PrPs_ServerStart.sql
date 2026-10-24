-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<广场启动>
--	2018/03/26	Jason		新增@chvHttpAddr參數
--	2018/07/2	alann		新增獲取熱更與支付域名
--	2018/09/11	alann		新增club域名
--  2019/10/17  mars		修改获取客户端平台版本号, 使用default(0)
--							回傳各渠道當前對應大廳風格的HallVersion
--	2019/10/22	Mars		增加GiftMoney, DefaultMoney #159
--	2019/10/29	Marshall	增加 平台渠道對應表、平台遊戲服務器對應表
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_ServerStart]
@sintServerID smallint,
@chvClientAddr VARCHAR(32),
@chvNotifyAddr VARCHAR(32),
@chvHttpAddr VARCHAR(32)
AS
SET NOCOUNT ON
UPDATE ServerInfo.PlazaServerList
SET ClientAddr = @chvClientAddr,
NotifyAddr = @chvNotifyAddr,
HttpAddr = @chvHttpAddr,
LastUpdateTime = GETDATE()
WHERE ServerID = @sintServerID

IF @@ROWCOUNT = 0
INSERT INTO ServerInfo.PlazaServerList
        ( ServerID ,
          ClientAddr,
		  NotifyAddr,
		  HttpAddr,
          LastUpdateTime
        )
SELECT
	@sintServerID,
	@chvClientAddr,
	@chvNotifyAddr,
	@chvHttpAddr,
	GETDATE()

--清除广场在线数据
DELETE Game.HallUserList WHERE ServerID = @sintServerID

--获取客户端平台版本号
SELECT * FROM ServerInfo.HallVersion with (nolock)
--獲取熱更與支付域名
SELECT  DLUpdate as UpdateDomain, Payment as BillDomain, Club as ClubDomain, Customer as CustomerDomain from CenterDB.ServerInfo.DomainConfig with (nolock) WHERE Company = 1
--獲取渠道包相關資訊
SELECT AreaID, ISNULL(AreaConfig, '') AS AreaConfig, ISNULL(GiftMoney, 0) AS GiftMoney, ISNULL(DefaultMoney, 0) AS DefaultMoney 
From Area.Area with (nolock)

/*  回傳不可使用的serverid  */
select AreaID,GameID,ServerID,FlagID,Status
from [ServerInfo].[ServerRelations] with (nolock)
where
	status = 0

/*  回傳各渠道對應大廳風格的HallVersion */
SELECT A.AreaID, 
		ISNULL(B.AndroidVersion, '') as AndroidVersion, 
		ISNULL(B.IOSVersion, '') as IOSVersion, 
		ISNULL(B.AndroidVersion2, '') as AndroidVersion2, 
		ISNULL(B.IOSVersion2, '') as IOSVersion2 
FROM (
    SELECT AreaID, JSON_VALUE(AreaConfig, '$.example.invalid.Template') as Skin
    From Area.Area with (nolock)
) AS A
JOIN ServerInfo.HallSkin AS S ON S.Code = A.Skin AND S.Status = 1
JOIN Area.Area AS R ON A.AreaID = R.AreaID
LEFT JOIN (
	SELECT PlatformID, 
			HallSkinID, 
			AndroidVersion = CONCAT(PlatformID, '_', Max(AnVersion)),
			AndroidVersion2 = CONCAT(PlatformID, '_', Max(AnVersion2)),
			IOSVersion = CONCAT(PlatformID, '_', Max(IOSVersion)), 
			IOSVersion2 = CONCAT(PlatformID, '_', Max(IOSVersion2))
	FROM (
		SELECT PlatformID, 
				HallSkinID, 
				AnVersion = CASE WHEN Type = 1 THEN AndroidVersion ELSE '' END, 
				AnVersion2 = CASE WHEN Type = 2 THEN AndroidVersion ELSE '' END, 
				IOSVersion = CASE WHEN Type = 1 THEN IOSVersion ELSE '' END, 
				IOSVersion2 = CASE WHEN Type = 2 THEN IOSVersion ELSE '' END
		FROM ServerInfo.HallVersions
	) AS A
	GROUP BY PlatformID, HallSkinID
) AS B ON S.HallSkinID = B.HallSkinID AND B.PlatformID = R.PlatformID 
ORDER BY AreaID ASC


--平台渠道對應表
SELECT AreaID , PlatformID 
FROM Area.Area


--平台遊戲服務器對應表
SELECT ID , PlatformID , GameID , ServerID , [Status]
FROM [CenterDB].[ServerInfo].[ServerPlatformRelations] 


RETURN 1

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_ServerStart] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_ServerStart] TO [xbuser]
    AS [dbo];

