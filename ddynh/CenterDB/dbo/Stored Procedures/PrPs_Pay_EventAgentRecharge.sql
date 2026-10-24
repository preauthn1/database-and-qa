-- =============================================
-- Author:		Mars
-- Create date: 2019/08/12
-- Description:	代理充值贈送比例
--  2019/08/19	mars		將活動獎勵贈送由11099改為21003
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Pay_EventAgentRecharge]
	@intUserID INT,
	@sintType SMALLINT = 3,	  --1:支付, 2:代理支付, 3: 其他
	@lngCurrentAmount BIGINT, --修改前的金币数(已乘100)
	@lngUpdateAmount BIGINT,  --更新金币数	(已乘100)  --12300
	@chvIPAddress VARCHAR(15),
	@lngFreeCashAmount BIGINT = 0 OUTPUT,
	@chvMailContent VARCHAR(1024) OUTPUT,
	@chvNotifyContent VARCHAR(1024) OUTPUT,
	@chvErrMsg VARCHAR(128) OUTPUT			--错误消息

AS
BEGIN
	SET NOCOUNT ON;
	
	--代理充值贈送比例
	DECLARE @Rate FLOAT,
			@EventID INT = 2,
			@intRate INT,
			@lngAmount BIGINT = 0,
			@intReturnValue INT = 1,
			@SourceTypeID SMALLINT = 11099
	
	EXEC [Club02].[dbo].[PrWeb_Event_ChargeBonusRateByUser_Get]
		@intUserID = @intUserID,
		@intEventID = @EventID,
		@Rate = @Rate OUTPUT,
		@chvMsg= @chvErrMsg OUTPUT
	
	SET @intRate = @Rate * 100
	SET @lngFreeCashAmount =  @lngUpdateAmount * (@intRate * 0.01)  --246

	IF @lngFreeCashAmount > 0 
	BEGIN
		EXEC @intReturnValue = dbo.PrWeb_UpdateUserCash
			@intUserID = @intUserID,
			@sintSourceType = @SourceTypeID,
			@lngUpdateAmount = @lngFreeCashAmount,
			@chvIPAddress = @chvIPAddress,
			@chvMemo = '代理充值优惠金',
			@lngCurrentAmount = @lngCurrentAmount OUTPUT,
			@chvErrMsg = @chvErrMsg OUTPUT	
	
		--代理支付活動 無開啟的平台不予新增; 計算流水
		EXEC Club02.[dbo].[PrWeb_Event_ChargeBonusEvent]
			@intUserID = @intUserID,
			@lngChargeAmount = @lngAmount,
			@intEventID = @EventID,  --1:充值返利, 2:代理支付
			@chvMsg = ''
		
		--流水限制log
		EXEC [dbo].[PrWeb_Money_FlowAmountLimit] 
				@intUserID = @intUserID,
				@sintType = @sintType,
				@intAuditType = @EventID,
				@intAmount = @lngUpdateAmount,  --增加金額/充值金額
				@intAuditAmount = @lngUpdateAmount,  --流水限制(1倍流水)
				@sintSoruceTypeID = @SourceTypeID,
				@chvRtnMsg = @chvErrMsg OUTPUT	--錯誤訊息
	
		SET @chvMailContent = '亲爱的玩家：
				您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 充值返利送' + CAST(@intRate as varchar) + '%
		                                                                                                                                  
			（如有任何疑问请联系客服）'
			
		SET @chvNotifyContent = '您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 充值返利送' + CAST(@intRate as varchar) + '%'
	END
	RETURN @intReturnValue
END