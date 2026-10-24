
-- =============================================
-- Author:		Mars
-- Create date: 2019/08/14
-- Description:	新增流水限額紀錄

--		2019/08/21		mars		增加最後流水總值, 依照上筆流水限制+

-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Money_FlowAmountLimit] 
	@intUserID INT,
	@sintType SMALLINT = 0,  --1:支付, 2:代理支付, 3: 其他
	@intAdminID INT = 0,
	@intAuditType INT,
	@intAmount BIGINT = 0,  --增加金額/充值金額
	@intAuditAmount INT = 0,  --流水限制
	@sintSoruceTypeID SMALLINT = NULL,
	@chvRtnMsg	VARCHAR(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @returnValue INT,
			@AuditAmount BIGINT = @intAuditAmount,
			@SumFlowAmount BIGINT = 0,
			@LastFlowLimit BIGINT = 0,
			@FlowLimit BIGINT = 0

	--取得玩家當時總流水
	SELECT @SumFlowAmount = SumFlowAmount FROM Users.UserInfo WHERE UserID = @intUserID

	--取得上筆總流水限制
	SELECT TOP 1 @LastFlowLimit = FlowLimit FROM Event.FlowAmountLimitLog WHERE UserID = @intUserID ORDER BY CreateTime DESC

	IF (@SumFlowAmount > @LastFlowLimit)
		SET @FlowLimit = @SumFlowAmount + @intAuditAmount
	ELSE
		SET @FlowLimit = @LastFlowLimit + @intAuditAmount
		
	--新增流水限制LOG
	INSERT INTO Event.FlowAmountLimitLog(UserID, [Type], SourceTypeID, EventID, Amount, SumFlowAmount, FlowAmountLimit, FlowLimit, CreateTime, Status) 
	VALUES(@intUserID, @sintType, @sintSoruceTypeID, @intAuditType, @intAmount, @SumFlowAmount, @AuditAmount, 0, getDate(), 1)

	IF (@@ROWCOUNT > 0)
	BEGIN
		SET @chvRtnMsg = '新增流水限制成功'
		RETURN 1
	END

	SET @chvRtnMsg = '新增流水限制失败'
	RETURN -1
	
END