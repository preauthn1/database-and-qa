-- =============================================
-- Author:  Mars
-- Create date: 2019/07/09
-- Description:	<完成支付>
-- Changelog:
--		2019/08/20	mars	增加首次充值活動
--		2019/08/20	mars	增加線下支付判斷不計算稽核流水
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Pay_FinishedAEOrder]
	@intOrderID			INT,					--订单ID	
	@lngAmount			BIGINT,					--充值金额(人民币)
	@chvIPAddress		VARCHAR(15),			--IP地址
	@chvTransID			VARCHAR(32),			--第三方订单号
	@chvTransData		VARCHAR(max),			--第三方数据
	@chvErrMsg			VARCHAR(128) OUTPUT		--返回消息
AS
BEGIN
	DECLARE @tintStatus TINYINT,
			@lngPayAmount BIGINT,
			@lngGameCashAmount BIGINT,
			@intUserID INT,
			@sintSourceTypeID SMALLINT,
			@chvMemo VARCHAR(128),
			@dtOrderCreateTime DATETIME,
			@lngFreeCashAmount BIGINT,
			@intPayTypeID INT,
			@offlinePayGWID INT,
			@offlinePayTypeID INT

	SET @lngFreeCashAmount=0

	--取得線下支付PayTypeID
	EXEC dbo.PrWeb_GetOfflinePay
		@intGWID = @offlinePayGWID OUTPUT,
		@intPayTypeID = @offlinePayTypeID OUTPUT,
		@chvRtnMsg = @chvErrMsg OUTPUT

	--查詢存款單
	SELECT @intPayTypeID = A.PayTypeID,
			@chvMemo = T.BankCode,
			@sintSourceTypeID = B.SourceTypeID,
			@intUserID = A.UserID,
			@lngPayAmount = A.Amount,
			@lngGameCashAmount = A.Amount * 100,
			@tintStatus = A.Status, 
			@dtOrderCreateTime = A.CreateTime 
	FROM Pay.OrderList AS A 
	LEFT JOIN Payment.PayType AS T ON T.TYPE = 1 AND T.Status = 1 AND A.PayTypeID = T.ID
	LEFT JOIN Payment.BankCodeType B ON B.BankCode = T.BankCode 
	WHERE A.Id = @intOrderID AND A.CreateTime > DATEADD(WW,-1,GETDATE());	--由于做了分区，只处理一周以内的订单
	
	IF @lngAmount <> @lngPayAmount
	BEGIN
		SET @chvErrMsg = '操作失败:充值金额不正确'
		RETURN -1
	END
	
	IF @lngPayAmount IS NULL
	BEGIN
		SET @chvErrMsg = '操作失败:充值渠道有问题,请联系客服人员'
		RETURN -1	
	END
	
	IF @tintStatus <> 1
	BEGIN
		SET @chvErrMsg = '操作失败:已经完成充值订单,不能重复提交'
		RETURN -1	
	END
	
	--更新订单状态
	UPDATE Pay.OrderList
	SET Status = 2,
		TransID = @chvTransID,
		TransData = TransData + '  ' + @chvTransData,
		LastUpdateTime = GETDATE() 
	WHERE Id = @intOrderID AND Status=1 AND CreateTime > DATEADD(WW,-1,GETDATE())
	
	--如果有更新
	IF @@rowcount > 0
	BEGIN
		DECLARE @intReturnValue INT,
				@lngCurrentAmount BIGINT;
				
		EXEC @intReturnValue = dbo.PrWeb_UpdateUserCash 
			@intUserID = @intUserID,
		    @sintSourceType = @sintSourceTypeID,
		    @lngUpdateAmount = @lngGameCashAmount,
		    @chvIPAddress = @chvIPAddress,
		    @chvMemo = @chvMemo,
		    @lngCurrentAmount = @lngCurrentAmount OUTPUT,
		    @chvErrMsg = @chvErrMsg OUTPUT		   							
		
		if (@intReturnValue <> 1)
		BEGIN
			RETURN -1
		END

		--遊戲內充值金額通知計算
		if exists(select 1 from Game.GameUserList with (nolock) where UserID=@intUserID)
			insert into Notify.Notify.PayFinishOrder(OrderID,UserID,Amount,TimeSeq) values(@intOrderID, @intUserID,@lngGameCashAmount+@lngFreeCashAmount, dbo.Fn_GetTimeSeq())
		
		--取用戶充值金額
		DECLARE @UserLevel	INT
		SELECT @UserLevel = [dbo].[Fn_ComputeGrade](SumCharge + SumAgentCharge + ABS(@lngGameCashAmount))
		FROM Users.UserInfo WITH (NOLOCK)
		WHERE
			UserID = @intUserID
		    
		--更新用户累计充值信息 更新用戶等級
		UPDATE Users.UserInfo
		SET SumCharge =  SumCharge + ABS(@lngGameCashAmount),
			GradeID = @UserLevel
		WHERE UserID = @intUserID
		
		DECLARE @chvMailContent varchar(1024)
		DECLARE @chvNotifyContent varchar(1024)

		/***** Event *******/
		--首次充值活動
		IF (@intPayTypeID != @offlinePayTypeID)  --線下充值不做
		EXEC @intReturnValue = dbo.PrPs_Pay_EventFirstRecharge 
				@intUserID = @intUserID,
				@sintType = 1,
				@lngUpdateAmount = @lngGameCashAmount,
				@chvIPAddress = @chvIPAddress,
				@lngCurrentAmount = @lngCurrentAmount OUTPUT,
				@lngFreeCashAmount = @lngFreeCashAmount OUTPUT,
				@chvMailContent = @chvMailContent OUTPUT,
				@chvNotifyContent = @chvNotifyContent OUTPUT,
				@chvErrMsg = @chvErrMsg OUTPUT

		IF @lngFreeCashAmount = 0 
		BEGIN 
			--流水限制log
			IF (@intPayTypeID != @offlinePayTypeID)  --線下充值不做
			EXEC [dbo].[PrWeb_Money_FlowAmountLimit] 
					@intUserID = @intUserID,
					@sintType = 1, 
					@intAuditType = 0,
					@intAmount = @lngGameCashAmount,  --增加金額/充值金額
					@intAuditAmount = @lngGameCashAmount,  --先以一倍流水做紀錄
					@sintSoruceTypeID = @sintSourceTypeID,
					@chvRtnMsg = @chvErrMsg OUTPUT	--錯誤訊息

			--充值到账提示
			SET @chvNotifyContent = '您充值的金币:' + dbo.Fn_ShowMoney(@lngGameCashAmount+@lngFreeCashAmount) + '已到账.'
			--发送到账邮件
			SET @chvMailContent = '亲爱的玩家：
					您充值的金币:' + dbo.Fn_ShowMoney(@lngGameCashAmount + @lngFreeCashAmount) + '已到账
				                                                                                                                                  
				（如有任何疑问请联系客服）'
		END

		--充值到账提示
		INSERT INTO Notify.Notify.Notify(UserID,Type,Message)
		select @intUserID,1,@chvNotifyContent

		--发送系统邮件
		EXEC PrPs_SendSysMail
					@intUserID, 
					'充值成功',
					@chvMailContent,
					0,
					NULL

		--活動充值紀錄
		declare @lngTotal bigint=@lngGameCashAmount+@lngFreeCashAmount
		EXEC dbo.[PrGs_Event_AddContestOrderLog] @intUserID, @lngTotal

	END
	
	ELSE
	BEGIN
		SET @chvErrMsg = '操作失败:已经完成充值订单,不能重复提交'
		RETURN -1	
	END	

	EXEC Club02.[dbo].[PrWeb_Split_BindingCheck]
		@intUserID = @intUserID,				--用户 ID
		@chvMsg	= ''

	SET @chvErrMsg = '操作成功'	
	RETURN 1
END
GO