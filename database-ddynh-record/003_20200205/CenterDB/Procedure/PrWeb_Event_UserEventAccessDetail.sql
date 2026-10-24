USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Event_UserEventAccessDetail')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Event_UserEventAccessDetail] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Jason
-- Create date: 2018/07/31
-- Description:	活動資格明細查詢
-- 	2020/03/06 	Mars 			增加回傳GiftMemo
-- 	2020/03/10 	Mars 			增加回傳EventSettingID
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Event_UserEventAccessDetail]
(
	@sintEventID	smallint = null,
	@intUserID		int = null,
	@dtStatTime		datetime = null,
	@dtEndTime		datetime = null,
	@intPageIndex		int=1,
	@intPageSize		int=20,
	@intPageCount		int output
)
AS
BEGIN
	SET NOCOUNT ON

	set @intPageCount = 0
	
	/*  回傳資料  */
	------------------------------------------------------------------------------------
	SELECT @intPageCount = COUNT(1) 
	from [Users].[EventDetailLog] as a with (nolock)
		inner join [Users].[EventSetting] as b with (nolock) on a.EventSettingID = b.Id
		inner join [Users].[UserInfo] as c with (nolock) on a.userid = c.userid
	where
		isnull(@sintEventID,b.EventType) = b.EventType
		and isnull(@intUserID,a.[UserID]) = a.[UserID]
		and isnull(@dtStatTime,a.[CreateTime]) >= a.[CreateTime]
		and isnull(@dtEndTime,a.[CreateTime]) <= a.[CreateTime]
	
	;with tab as 
	(
		select	row_number() over (order by a.id desc) as rowid,
				a.[ID],
				a.EventSettingID,
				b.EventType,
				b.EventName,
				b.StartTime,
				b.EndTime,
				a.[UserID],
				a.LoginName,
				a.[CreateTime],
				a.[GiftCash],
				a.[GiftMemo],
				a.[IPAddress]
		from [Users].[EventDetailLog] as a with (nolock)
		inner join [Users].[EventSetting] as b with (nolock) on a.EventSettingID = b.Id
		where
			isnull(@sintEventID,a.EventSettingID) = a.EventSettingID
			and isnull(@intUserID,a.[UserID]) = a.[UserID]
			and isnull(@dtStatTime,a.[CreateTime]) >= a.[CreateTime]
			and isnull(@dtEndTime,a.[CreateTime]) <= a.[CreateTime]
	)
	SELECT * FROM tab WHERE rowid between @intPageSize * (@intPageIndex -1) + 1 and @intPageSize * @intPageIndex	
	------------------------------------------------------------------------------------

	set @intPageCount = isnull(@intPageCount,0)
END
