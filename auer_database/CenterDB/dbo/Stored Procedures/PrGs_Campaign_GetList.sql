




-- =============================================
-- Author: Eddie
-- Create date: 2019/07/18
-- Description: 取得平台活動清單 by UserID (給客戶端顯示用)
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Campaign_GetList]
@intUserID INT = null
AS
BEGIN
	Select Id,Picture,SeqID,Title,Tag as CampaignTag,Behavior as CampaignBehavior,Link,StartTime,EndTime from [Area].[Campaign] A with (nolock) 
	join [Users].UserInfo B with(nolock) on A.AreaID = B.AreaID
	Where B.UserID = @intUserID and A.[Status] = 1 and A.StartTime <= getdate() and A.EndTime >= getdate()
END

