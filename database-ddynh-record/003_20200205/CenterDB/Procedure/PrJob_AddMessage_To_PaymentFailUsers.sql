USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrJob_AddMessage_To_PaymentFailUsers')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrJob_AddMessage_To_PaymentFailUsers] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marshall
-- Create date: 2019-10-01
-- Description:	排程_檢查是否有用戶_存款失敗或Pending
-- 2019/10/08		Mars 		修正支付失敗的篩選
-- 2020/02/05 		Mars 		修改支付通知內容
-- 2020/02/13 		Louis 		修改支付通知內容
-- =============================================
ALTER PROCEDURE [dbo].[PrJob_AddMessage_To_PaymentFailUsers]
	
AS
BEGIN
	
	SET NOCOUNT ON;


	DECLARE @mainSubType int = 21; --此編號歸類為 支付通知 (請參考 enum)
	DECLARE @mute_internal int = 5; --最多幾分鐘收到一次通知
	DECLARE @userIDs_count int
	DECLARE @userIDs dbo.ListInt


	---查出近期
	INSERT INTO @userIDs
	SELECT distinct UserID from [Pay].[OrderList]
	WHERE 
	(
		(CreateTime >= DATEADD(MINUTE , -1 * @mute_internal * 2 , GETDATE()) AND Status = 3) 
		OR
		(CreateTime >= DATEADD(MINUTE , -1 * @mute_internal * 3 , GETDATE()) AND Status = 1  AND  DATEDIFF(MINUTE,CreateTime,GETDATE()) > 10 )
	)	
	AND UserID not in
	(
		SELECT UserID FROM Message.ReceiveUser AS R with(nolock)
		JOIN Message.MessageList AS L ON R.MsgID = L.MsgID 
		WHERE L.SubType = @mainSubType AND L.CreateTime >= DATEADD(MINUTE , -1 * @mute_internal , GETDATE())
	)

	SET @userIDs_count = ( SELECT count(*) FROM @userIDs)

	IF @userIDs_count = 0

		BEGIN

			RETURN 0;

		END

	ELSE
		BEGIN

			DECLARE @content VARCHAR(1024)
			SET @content = '尊敬的会员您好：
因收到您在刚才提交的充值订单未成功支付，若您在充值步骤上有遇到任何问题，可直接联系在线客服洽询，感谢您的支持与爱护，祝您游戏愉快！！'
		
			EXEC [PrPs_SendSysMail_ToMultiUsers] 
			@userIDs, 
			'支付通知', 
			@content,  
			1, 
			@mainSubType

			SELECT 1
		END

END
