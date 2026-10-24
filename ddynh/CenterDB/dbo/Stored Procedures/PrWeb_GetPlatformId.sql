
-- =============================================
-- Author:  Mars
-- Create date: 2019/07/17
-- Description: 取得平台ID
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPlatformId]
(
	@intUserID int = 0,
	@intPlatformID int = 0 OUTPUT,
	@chvRtnMsg varchar(50) = '' OUTPUT --錯誤訊息
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT @intPlatformID = A.PlatformID FROM Users.UserInfo AS U JOIN Area.Area AS A ON A.AreaID = U.AreaID WHERE U.UserID = @intUserID
	
	IF (@@ROWCOUNT > 0)
		SET @chvRtnMsg = '操作成功'
	ELSE
		SET @chvRtnMsg = '查無資料'
		
	RETURN 1
END