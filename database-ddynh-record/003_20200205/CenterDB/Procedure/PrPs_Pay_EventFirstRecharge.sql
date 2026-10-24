USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrPs_Pay_EventFirstRecharge')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrPs_Pay_EventFirstRecharge] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO

/****** Object:  StoredProcedure [dbo].[PrPs_Pay_EventFirstRecharge]    Script Date: 2020/2/18 下午 12:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mars
-- Create date: 2019/08/12
-- Description:	首次充值赠送N％彩金(根據設定)

--  2019/08/19	mars			將活動獎勵贈送由11099改為21003
--  2019/10/28  mars			增加判斷活動是否有效 #462
--  2019/11/25  marshall		首儲的設定改成讀取另一張新table
--  2020/02/18  marshall		首儲要判斷贈送最大金幣數
-- =============================================

ALTER PROCEDURE [dbo].[PrPs_Pay_EventFirstRecharge]
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
	DECLARE @setting_maxLimitValue		BIGINT;

	
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
		 @output_BonusFlowRate = @setting_bonusFlowRate OUTPUT,
		 @output_MaxLimitValue = @setting_maxLimitValue OUTPUT
		 
	
	IF (@setting_isEventEnable != 1)
	BEGIN
		SET @chvErrMsg = '活动已关闭'
		RETURN @intReturnValue
	END
	
	IF @setting_bonusRate > 0 
	BEGIN

		SET @lngFreeCashAmount =  @lngUpdateAmount * @setting_bonusRate	* 0.01				--充值獎勵(要再轉換成除以100)
		
		--如果有設定上限值
		IF(@setting_maxLimitValue is not NULL AND @setting_maxLimitValue != 0)
		BEGIN
			SET @lngFreeCashAmount = @setting_maxLimitValue
		END		


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


		DECLARE @maxLimitValueText nvarchar(50);

		IF @setting_maxLimitValue is null
			BEGIN
				SET @maxLimitValueText = '无';
			END
		ELSE
			BEGIN
				SET @maxLimitValueText = CAST((@setting_maxLimitValue / 100) as nvarchar(50)) 
			END
	
		SET @chvMailContent = '亲爱的玩家：
				您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 首次充值返利送' + CAST(@setting_bonusRate as varchar) 
				+ '% (最高上限:' + @maxLimitValueText   + ')		                                                                                                                                  
			  （如有任何疑问请联系客服）'

			
		SET @chvNotifyContent = '您充值的金币:' + dbo.Fn_ShowMoney(@lngUpdateAmount + @lngFreeCashAmount) + '已到账, 首次充值返利送' + CAST(@setting_bonusRate as varchar) + '%'
			+ '(最高上限:' + @maxLimitValueText   + ')'


	END

	RETURN @intReturnValue
END