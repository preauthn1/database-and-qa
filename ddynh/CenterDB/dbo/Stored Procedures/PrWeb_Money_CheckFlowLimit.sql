
-- =============================================
-- Author:		Mars
-- Create date: 2019/08/22
-- Description:	檢查流水

-- 2019-10-28		Marshall		調整欄位型別
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Money_CheckFlowLimit] 
	@intUserID INT,
	@chvRtnMsg	VARCHAR(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SumFlowAmount BIGINT = 0,
		@CurID BIGINT,
		@CurAmount BIGINT,
		@CurSumFlowAmount BIGINT,
		@CurFlowAmountLimit BIGINT,
		@CurFlowLimit BIGINT,
		@CurCreateTime DATETIME,
		@CurStatus INT

	--取得當前流水
	SELECT @SumFlowAmount = SumFlowAmount FROM Users.Userinfo WHERE UserID = @intUserID  --10000
	
	DECLARE Cur CURSOR FOR
		--取得未確認流水
		SELECT ID, Amount, SumFlowAmount, FlowAmountLimit, FlowLimit, CreateTime, Status FROM [Event].[FlowAmountLimitLog] WHERE UserID = @intUserID AND Status = 1 ORDER BY CreateTime ASC
	OPEN Cur
	FETCH NEXT FROM Cur INTO @CurID, @CurAmount, @CurSumFlowAmount, @CurFlowAmountLimit, @CurFlowLimit, @CurCreateTime, @CurStatus
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    --當輸贏流水大於稽核流水, 那就將STATUS改為2
		--IF (@SumFlowAmount > (@CurSumFlowAmount + @CurFlowAmountLimit))
		IF (@SumFlowAmount >= @CurFlowLimit)
		BEGIN
			UPDATE [Event].[FlowAmountLimitLog] SET Status = 2 WHERE ID = @CurID
		END
	
	    FETCH NEXT FROM Cur
	    INTO @CurID, @CurAmount, @CurSumFlowAmount, @CurFlowAmountLimit, @CurFlowLimit, @CurCreateTime, @CurStatus
	END
	
	CLOSE Cur
	DEALLOCATE Cur
	
END