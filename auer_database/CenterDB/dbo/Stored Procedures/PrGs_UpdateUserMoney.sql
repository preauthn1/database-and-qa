-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<更新用户金币>
--	2018-03-19	Jason		新增@StartStatTime , @EndStatTime做為取資料時使用
--	2018/04/12	Jason		原更新金幣統計有多個SP執行相同語法改為呼叫SP執行
--  2018/06/25  Jason 		更新禮碼欄位
--	2019/08/02	Eddie		增加首充返利活動 PrPs_Event_FirstDeposit_AddWinAmount
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_UpdateUserMoney]
	@intMsgID			int,			--请求的消息ID(用于验证是否已经请求过)
	@intUserID			int,			--用户ID
	@lngUpdateAmount	bigint,			--变化数量
	@lngTaxAmount		bigint=null,	--税收数量
	@intServerID		int,			--房间ID
	@lngCouponAmount	BIGINT = NULL
AS
BEGIN

	
	DECLARE @NowTime		DATETIME = GETDATE()
	
	
	--如果消息已处理则直接返回
	DECLARE @isMsgExists int
	EXEC @isMsgExists = dbo.PrGs_CheckNetworkMsgIsExists @intServerID,@intMsgID
	IF @isMsgExists = 1
	BEGIN
		--2019/07/20 Eddie----
		Insert into [Log].[RejectedNetworkMsgLog] (ServerID, MsgID, UserID)
		values (@intServerID, @intMsgID, @intUserID)
		-----------------------
		RETURN 1
	END	
	
	SET @lngCouponAmount = ISNULL(@lngCouponAmount,0)
	
	
	IF @lngUpdateAmount<>0 OR @lngCouponAmount <> 0
	BEGIN
		BEGIN TRANSACTION

		DECLARE @bitIsRight BIT,@lngCurrentAmount BIGINT

		
		UPDATE Money.Cash
		SET @bitIsRight = CASE WHEN Amount + @lngUpdateAmount<0 THEN 0 ELSE 1 END
		,@lngCurrentAmount = Amount
		,Amount = CASE WHEN Amount + @lngUpdateAmount<0 THEN 0 ELSE Amount + @lngUpdateAmount END
		,Code = ''
		,[CouponAmount] = CASE WHEN [CouponAmount] + @lngCouponAmount < 0 THEN 0 ELSE [CouponAmount] + @lngCouponAmount END
		WHERE UserID = @intUserID
				
		IF @@ROWCOUNT>0 
		BEGIN		


			IF @bitIsRight = 0
			BEGIN 
				INSERT INTO Game.WarningLog
				(Memo, WriteTime)
				SELECT
				'现金不足, ' + CAST(@intUserID AS varchar)+',当前数量' + CAST(@lngCurrentAmount AS varchar) + ',更新数量' + CAST(@lngUpdateAmount AS VARCHAR),GETDATE()		
			END

		END
		ELSE
		BEGIN

			INSERT INTO Game.WarningLog
			(Memo, WriteTime)
			SELECT
			'更新了不存在的用户ID'+cast(@intUserID as varchar),GETDATE()		

		END
		
	
						
		/*  --更新金币统计  */
		------------------------------------------------------------------------------------------
		EXEC [dbo].[PrWeb_UpdateMoneySourceLog]
			@intUserID			= @intUserID,
			@intServerID		= @intServerID,
			@lngUpdateAmount	= @lngUpdateAmount,	
			@lngTaxAmount		= @lngTaxAmount,	
			@CreateTime			= @NowTime
		------------------------------------------------------------------------------------------

		
		--判断用户这一局赢的钱是否需要发全服公告
		IF @lngUpdateAmount>0 AND EXISTS(SELECT 1 FROM Game.WinAnnConfig where GameID in(select GameID from ServerInfo.GameServerList where ServerID=@intServerID) and UpperLimit<=@lngUpdateAmount) 
		BEGIN
			INSERT INTO Game.WinAnn(UserID,ServerID,WinAmount,Status,CreateTime)
			SELECT @intUserID,@intServerID,@lngUpdateAmount,0,GETDATE()
		END	
		
		
		--充值返利活動
		IF @lngUpdateAmount>0 and @intServerID not in (Select ServerID From [Event].[FirstDepositExcludeServerID] with(nolock))
		BEGIN
			EXEC PrPs_Event_FirstDeposit_AddWinAmount
				@intUserID,
				@lngUpdateAmount,
				@chvErrMsg = ''
		END
		
		DECLARE @intCheckAmount bigint = CASE WHEN @bitIsRight = 0 THEN 0 ELSE @lngCurrentAmount + @lngUpdateAmount END

		IF NOT EXISTS (SELECT 1 FROM Money.Cash WHERE UserID = @intUserID AND Amount = @intCheckAmount)
		BEGIN
			ROLLBACK
		
			INSERT INTO [CenterDB].[Log].[UpdateUserMoney] 
					  ( [MsgID], [UserID], [UpdateAmount], [TaxAmount], [ServerID], [CouponAmount], [CurrentAmount], [CreateTime])
				 SELECT @intMsgID,@intUserID,@lngUpdateAmount,@lngTaxAmount,@intServerID,@lngCouponAmount,@lngCurrentAmount,GETDATE()

			RETURN 0
		END

		COMMIT		
	END
	RETURN 1
END