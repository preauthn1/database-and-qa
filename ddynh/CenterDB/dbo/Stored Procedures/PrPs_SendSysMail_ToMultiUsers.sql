-- =============================================
-- Author:  Marshall
-- Create date: 2019-10-01
-- Description:	一次發送多個信件給用戶
-- =============================================

CREATE PROCEDURE [dbo].[PrPs_SendSysMail_ToMultiUsers]
@insertIDs dbo.ListInt READONLY,		--收件人IDs(多筆)
@chvTitle VARCHAR(128),					--邮件标题
@chvContent VARCHAR(1024),				--邮件内容
@intSort INT,							--排序
@intSubType INT = 1,					--次分類
@intMsgID INT = 0 OUTPUT					--消息ID (output參數)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @NowTime	DATETIME = GETDATE()
	DECLARE @NotifyType	TINYINT = 1


	--Step 1. 消息內文
	INSERT INTO Message.MessageList ( Title, MsgContent, [Type] , FromUserID, Sort, CreateTime , SubType)
	SELECT	@chvTitle,	@chvContent,1, NULL, @intSort, GETDATE() , @intSubType
	
	SET @intMsgID = @@IDENTITY

	
	--Step 2. 消息關聯使用者
	INSERT INTO Message.ReceiveUser (MsgID, UserID, Status, ReadTime )
	SELECT @intMsgID , Value , 0 , NULL 
	FROM @insertIDs	
	
	
	--Step 3. 通知notify
	INSERT INTO Notify.Notify.Attr ( UserID, TypeID, Param,	Status,	CreateTime,	LastPostTime     )
	SELECT	Value ,@NotifyType,	0,	0, GETDATE() , GETDATE()
	FROM @insertIDs


	RETURN 1
END