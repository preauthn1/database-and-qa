-- =============================================
-- Author:  Mars
-- Create date: 2019/08/28
-- Description:	取得平台短信(SMS)設定
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetSMSVenderInfo]
(
	@intUserId			INT,
	@chvVenderName		VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT S.SMSSettingId, 
			S.SMSId, 
			C.Name as SMSName,
			S.SMSInfo,
			S.Sort,
			S.Status,
			S.CreateTime
	FROM ServerInfo.SMSSetting AS S
	JOIN ServerInfo.SMSConfig AS C ON C.id = S.SMSId 
	JOIN Area.Platform AS P ON P.PlatformID = S.PlatformID
	JOIN Area.Area AS A ON A.PlatformID = P.PlatformID
	JOIN Users.UserInfo AS U ON U.UserID = @intUserId AND U.AreaID = A.AreaID
	WHERE C.vender = @chvVenderName
END