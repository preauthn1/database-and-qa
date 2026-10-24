
-- =============================================
-- Author:  Marshall
-- Create date: 2019/09/24
-- Description:	複製活動

--		2019-10-23		Marshall		phase2.新增的欄位沒有複製到
--		2019-11-22		Marshall		移除areaID欄位
--		2019-11-25		Marshall		改成以platfotmID當基準複製(以前是areaID)
-- =============================================

CREATE PROCEDURE [dbo].[PrWeb_CopyEventToTargetPlatforms]  
   @TemplateEventIDs	dbo.ListInt READONLY,
   @TargetPlatformIDs		dbo.ListInt READONLY,
   @UpdateBy			nvarchar(500) = 'system'

      AS	  
	  BEGIN	  
	  
		SET XACT_ABORT ON;
		BEGIN TRAN;


			-- Step 1. 複製活動
			INSERT INTO [Event].[PromotionEvent] (PlatformID,[Title],[Memo],[Status],[EventStartTime],[EventEndTime],[CreateTime],[UpdateTime],[UpdateBy],[ParentTemplateID])
			SELECT j.[Value],[Title],'copy(活动复制产生)',[Status],[EventStartTime],[EventEndTime],GETDATE(),GETDATE(),@UpdateBy,[EventID]
			FROM [Event].[PromotionEvent] 
			LEFT JOIN @TargetPlatformIDs as j on j.[Value] = j.[Value]
			WHERE EventID in
			(
				SELECT [Value] FROM @TemplateEventIDs
			)		

			-- Step 2. 複製活動Item設定 (彈窗、公告設定)
			INSERT INTO [Event].[PromotionEventItem] ([EventID],[Type],[ImageUrlDomain],[ImageUrl],[Status],[Sort],[Tags],[BehaviorType],[BehaviorSettingValue],[DisplayMode],[Content])
			SELECT a.EventId , j.Type , j.ImageUrlDomain , j.ImageUrl , j.Status , j.Sort , j.Tags , j.BehaviorType , j.BehaviorSettingValue ,j.DisplayMode ,j.Content
			FROM [Event].[PromotionEvent] as a
			LEFT JOIN [Event].[PromotionEventItem] as j on a.ParentTemplateID = j.EventId
			WHERE a.ParentTemplateID in (SELECT [Value] FROM @TemplateEventIDs) AND a.CreateTime >= DATEADD(minute, -1, GETDATE()) AND a.EventID not in 
			(
				SELECT EventID FROM [Event].[PromotionEventItem]
			)

			
		COMMIT TRAN; 

	  END