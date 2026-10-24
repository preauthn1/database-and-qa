-- =============================================
-- Author:		Marshall
-- Create date: 2018-09-19
-- Description:	郵件頁，要顯示的活動清單

-- 2019-10-15	Marshall 新增欄位 DisplayMode、Content
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Event_GetPromotionEvents_Announcement]	
	@AreaID int 
AS
BEGIN
	SET NOCOUNT ON;
		
	--公告活動
	SELECT a.EventID , m.AreaID , Title , EventStartTime , EventEndTime , (ImageUrlDomain + ImageUrl) as ImageUrl , Sort , b.Tags , b.DisplayMode , ISNULL(b.Content ,'') as Content
	FROM [Event].[PromotionEvent] as a
	LEFT JOIN [Event].[PromotionEventItem] as b on a.EventId = b.EventID 	
	LEFT JOIN [Event].[PromotionEventAreaMapping] as m on a.EventId = m.EventID
	WHERE b.Type = 2 AND a.Status = 1 AND b.Status = 1 AND (GETDATE() BETWEEN a.EventStartTime AND a.EventEndTime) AND m.AreaID = @AreaID
	ORDER BY Sort


END