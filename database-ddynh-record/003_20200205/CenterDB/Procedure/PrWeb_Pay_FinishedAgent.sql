USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrWeb_Pay_FinishedAgent')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrWeb_Pay_FinishedAgent] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: alan
-- Create date: 2018/7/1
-- Description:	完成代理充值
-- Changelog:
--	2018/08/08	alan		#656 新增代理推廣系統抽成
--	2019/05/11	Jason		增加裂變檢查
--  2019/06/17	minglung	增加充值返利
--  2019/07/30	mars		增加代理支付活動 & 增加區域變數@lngAmount
--  2019/08/19	mars		將活動獎勵由11099改為21003
-- =============================================
ALTER PROCEDURE [dbo].[PrWeb_Pay_FinishedAgent]
	@intUserID				INT,					--用户ID
	@sintSourceType			SMALLINT,				--金币变化类型
	@lngUpdateAmount		BIGINT,					--更新金币数	
	@chvIPAddress			VARCHAR(15),			--IP地址
	@chvMemo				VARCHAR(128),			--备注
	@lngCurrentAmount		BIGINT OUTPUT,			--修改前的金币数
	@chvErrMsg			VARCHAR(128) OUTPUT			--错误消息
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @intReturnValue INT,
			@lngAmount BIGINT = @lngUpdateAmount

	EXEC @intReturnValue = dbo.PrWeb_UpdateUserCash
		@intUserID = @intUserID,
		@sintSourceType = @sintSourceType,
		@lngUpdateAmount = @lngUpdateAmount,
		@chvIPAddress = @chvIPAddress,
		@chvMemo = @chvMemo,
		@lngCurrentAmount = @lngCurrentAmount OUTPUT,
		@chvErrMsg = @chvErrMsg OUTPUT	

	IF @intReturnValue = 1 AND @lngUpdateAmount > 0
	BEGIN
		--遊戲內充值金額通知計算
		if exists(select 1 from Game.GameUserList with (nolock) where UserID = @intUserID)	
			insert into Notify.Notify.PayFinishOrder(OrderID,UserID,Amount,TimeSeq) values(0, @intUserID,@lngUpdateAmount,dbo.Fn_GetTimeSeq())
				
		--取用戶充值金額
		DECLARE @UserLevel	INT
		SELECT @UserLevel = [dbo].[Fn_ComputeGrade](SumCharge + SumAgentCharge + ABS(@lngUpdateAmount))
		FROM Users.UserInfo WITH (NOLOCK)
		WHERE
			UserID = @intUserID
		    
		--更新用户累计代理充值信息 更新用戶等級
		UPDATE Users.UserInfo
		SET SumAgentCharge =  SumAgentCharge + ABS(@lngUpdateAmount),
			GradeID = @UserLevel
		WHERE UserID = @intUserID			

		--发送到账邮件
		declare @lngFreeCashAmount	BIGINT=0
		declare @chvMailContent		varchar(1024)
		declare @chvNotifyContent	varchar(1024)
		declare @intRate			int
		
		/***** Event *******/
		--首次充值活動
		EXEC @intReturnValue = dbo.PrPs_Pay_EventFirstRecharge 
				@intUserID = @intUserID,
				@sintType = 2,
				@lngUpdateAmount = @lngAmount,		--更新金币数	
				@chvIPAddress = @chvIPAddress,
				@lngCurrentAmount = @lngCurrentAmount OUTPUT, --修改前的金币数
				@lngFreeCashAmount = @lngFreeCashAmount OUTPUT,
				@chvMailContent = @chvMailContent OUTPUT,
				@chvNotifyContent = @chvNotifyContent OUTPUT,
				@chvErrMsg = @chvErrMsg OUTPUT

		IF @lngFreeCashAmount = 0 
		BEGIN 
			--代理支付2%活動
			EXEC @intReturnValue = dbo.PrPs_Pay_EventAgentRecharge 
					@intUserID = @intUserID,
					@sintType = 2,
					@lngCurrentAmount = @lngCurrentAmount,		--修改前的金币数(已乘100)
					@lngUpdateAmount = @lngAmount,				--更新金币数	(已乘100)
					@chvIPAddress = @chvIPAddress,
					@lngFreeCashAmount = @lngFreeCashAmount OUTPUT,
					@chvMailContent = @chvMailContent OUTPUT,
					@chvNotifyContent = @chvNotifyContent OUTPUT,
					@chvErrMsg = @chvErrMsg OUTPUT
					
			IF @lngFreeCashAmount = 0 
			BEGIN
				SET @chvMailContent = '亲爱的玩家：
						您充值的金币:'+dbo.Fn_ShowMoney(@lngUpdateAmount)+'已到账
				                                                                                                                                  
					（如有任何疑问请联系客服）'

				SET @chvNotifyContent = '您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount) + '已到账'
			END
		END

		
		--充值到账提示
		INSERT INTO Notify.Notify.Notify(UserID,Type,Message)
		SELECT @intUserID,1,@chvNotifyContent

		--发送系统邮件
		EXEC PrPs_SendSysMail
					@intUserID, 
					'充值成功',
					@chvMailContent,
					0,
					NULL

		--活動充值紀錄
		DECLARE @lngTotal bigint = @lngUpdateAmount + @lngFreeCashAmount
		EXEC dbo.[PrGs_Event_AddContestOrderLog] @intUserID, @lngTotal
	END

	EXEC Club02.[dbo].[PrWeb_Split_BindingCheck]
		@intUserID = @intUserID,				--用户 ID
		@chvMsg	= ''
		
	RETURN @intReturnValue
END