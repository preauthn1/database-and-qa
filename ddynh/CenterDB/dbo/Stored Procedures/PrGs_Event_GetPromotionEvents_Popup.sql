-- =============================================
-- Author:		Marshall
-- Create date: 2018-09-19
-- Description:	App首頁的彈出活動清單
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Event_GetPromotionEvents_Popup]	
	@AreaID int 
AS
BEGIN
	SET NOCOUNT ON;


	--彈出活動
	SELECT a.EventID , m.AreaID , Title , EventStartTime , EventEndTime , (ImageUrlDomain + ImageUrl) as ImageUrl , Sort , b.BehaviorType , ISNULL(b.BehaviorSettingValue , '') as BehaviorSettingValue
	FROM [Event].[PromotionEvent] as a
	LEFT JOIN [Event].[PromotionEventItem] as b on a.EventId = b.EventID
	LEFT JOIN [Event].[PromotionEventAreaMapping] as m on a.EventId = m.EventID
	WHERE b.Type = 1 AND a.Status = 1 AND b.Status = 1 AND m.AreaID = @AreaID AND (GETDATE() BETWEEN a.EventStartTime AND a.EventEndTime)
	ORDER BY Sort


END