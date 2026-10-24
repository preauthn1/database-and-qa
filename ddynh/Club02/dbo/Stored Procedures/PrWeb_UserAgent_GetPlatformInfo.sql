-- =============================================

-- Author:  jason
-- Create date: 2019/04/18
-- Description: Agent777後台 使用AdminID抓取PlatformID、PlatformName

--  2019/07/24	Amy	重寫
--  2019/09/11	Marshall調整分成type=0 與 其他

-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_UserAgent_GetPlatformInfo]
@intAdminID int = 1
AS
BEGIN

	set nocount on

	DECLARE @adminType int;

	SELECT @adminType = AdminType FROM [dbo].[AgentAdminUser] 
	WHERE ID = @intAdminID


	--adminType有四種+ 請參考enum，0為最高管理員

	IF @adminType = 0
		BEGIN
				
			--若是最高管理員 查全部
			SELECT a.PlatformID, a.Name as PlatformName, @intAdminID as AdminID
			FROM CenterDB.[Area].[Platform] as a with(nolock) 

		END
	ELSE
		BEGIN
		
			SELECT a.PlatformID, a.Name as PlatformName, b.AdminID 
			FROM CenterDB.[Area].[Platform] as a with(nolock) 
			inner join [Club02].[dbo].[AgentPlatformRelations] as b with(nolock) on a.PlatformID = b.PlatformID
			where b.AdminID = @intAdminID

		END

	return 1
END







