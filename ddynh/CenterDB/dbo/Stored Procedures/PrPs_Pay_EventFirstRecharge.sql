-- =============================================
-- Author:		Mars
-- Create date: 2019/08/12
-- Description:	首次充值赠送10％彩金

--  2019/08/19	mars			將活動獎勵贈送由11099改為21003
--  2019/10/28  mars			增加判斷活動是否有效 #462
--  2019/11/25  marshall		首儲的設定改成讀取另一張新table
-- =============================================

CREATE PROCEDURE [dbo].[PrPs_Pay_EventFirstRecharge]
	@intUserID INT,
	@sintType SMALLINT = 3,	  --1:支付, 2:代理支付, 3: 其他
	@lngUpdateAmount BIGINT,  --更新金币数(已經乘*100)
	@chvIPAddress VARCHAR(15),
	@lngCurrentAmount BIGINT OUTPUT, --修改前的金币数
	@lngFreeCashAmount BIGINT = 0 OUTPUT,
	@chvMailContent VARCHAR(1024) OUTPUT,
	@chvNotifyContent VARCHAR(1024) OUTPUT,
	@chvErrMsg VARCHAR(128) OUTPUT			--错误消息
AS

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @intReturnValue INT, 
			@intSumCharge INT, 	
			@lngAmount BIGINT = 0,
			@SourceTypeID SMALLINT = 11099,
			@flowLimit BIGINT


	DECLARE @setting_isEventEnable		BIGINT;
	DECLARE @setting_eventSettingID		int;
	DECLARE @setting_bonusRate			decimal(18,2);
	DECLARE @setting_bonusFlowRate		int;

	
	--查出用戶累計充值总额, SumCharge + SumAgentCharge 
	SELECT @intSumCharge = (SumCharge + SumAgentCharge)
	FROM Users.UserInfo WITH (NOLOCK)
	WHERE UserID = @intUserID


	--判斷更新金币数等於當前充值總額為首存
	IF (@intSumCharge != @lngUpdateAmount)
	BEGIN
		SET @chvErrMsg = '非首次充值'
		RETURN 1
	END
	

	--透過這支SP，查出首儲活動的設置參數
	EXEC [dbo].[PrPs_Event_GetFirstBonusEventSetting]
		 @intUserID = @intUserID,
		 @userChargeAmount = @lngUpdateAmount,
		 @output_isEventExist = @setting_isEventEnable OUTPUT,
		 @output_eventSettingID = @setting_eventSettingID OUTPUT,
		 @output_BonusRate = @setting_bonusRate OUTPUT,
		 @output_BonusFlowRate = @setting_bonusFlowRate OUTPUT
		 
	
	IF (@setting_isEventEnable != 1)
	BEGIN
		SET @chvErrMsg = '活动已关闭'
		RETURN @intReturnValue
	END
	
	IF @setting_bonusRate > 0 
	BEGIN

		SET @lngFreeCashAmount =  @lngUpdateAmount * @setting_bonusRate	* 0.01				--充值獎勵(要再轉換成除以100)
		SET @flowLimit = (@lngUpdateAmount + @lngFreeCashAmount) * @setting_bonusFlowRate	--流水倍數

		EXEC @intReturnValue = dbo.PrWeb_UpdateUserCash
			@intUserID = @intUserID,
			@sintSourceType = @SourceTypeID,
			@lngUpdateAmount = @lngFreeCashAmount,
			@chvIPAddress = @chvIPAddress,
			@chvMemo = '首次充值优惠金',
			@lngCurrentAmount = @lngCurrentAmount OUTPUT,
			@chvErrMsg = @chvErrMsg OUTPUT	
	
	
		--稽核流水限制log
		EXEC [dbo].[PrWeb_Money_FlowAmountLimit] 
				@intUserID = @intUserID,
				@sintType = @sintType,
				@intAuditType = @setting_eventSettingID,
				@intAmount = @lngUpdateAmount,  --增加金額/充值金額
				@intAuditAmount = @flowLimit,  --流水限制
				@sintSoruceTypeID = @SourceTypeID,
				@chvRtnMsg = @chvErrMsg OUTPUT	--錯誤訊息
	
		SET @chvMailContent = '亲爱的玩家：
				您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 首次充值返利送' + CAST(@setting_bonusRate as varchar) + '%
		                                                                                                                                  
			（如有任何疑问请联系客服）'
			
		SET @chvNotifyContent = '您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 首次充值返利送' + CAST(@setting_bonusRate as varchar) + '%'


	END

	RETURN @intReturnValue
END