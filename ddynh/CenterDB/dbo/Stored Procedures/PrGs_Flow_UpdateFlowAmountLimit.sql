-- =============================================
-- Author:  <Mars>
-- Create date: <2019/08/23>
-- Description:	<更新稽核流水>
--	2019/08/23	Mars		新增LOG寫入GameID,AreaID
--  2019/09/04	Mars		修正當已達流水被覆寫
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Flow_UpdateFlowAmountLimit]
(
	@intUserID			INT,					--用户ID
	@lngFlowAmount		BIGINT,					--輸贏流水
	@chvErrMsg			VARCHAR(128) OUTPUT
)
AS
BEGIN

	DECLARE @CurRowNumber BIGINT, 
			@CurID BIGINT, 
			@CurAmount BIGINT,			--存款金額
			@CurSumFlowAmount BIGINT,	--當下輸贏流水
			@CurFlowAmountLImit BIGINT, --新增稽核流水
			@CurFlowLimit BIGINT,		--已達流水
			@Now DateTime = getDate(),
			@Amount BIGINT

	DECLARE Cur CURSOR FOR
		SELECT ROW_NUMBER() OVER (ORDER BY ID DESC) as RN, ID, Amount, SumFlowAmount, FlowAmountLimit, FlowLimit 
		FROM Event.FlowAmountLimitLog 
		WHERE UserId = @intUserID 
			AND Status = 1 
		ORDER BY ID ASC
	OPEN Cur

	IF (@@CURSOR_ROWS > 0)
	BEGIN
							/*		存款金額	當下輸贏流水		新增稽核流水		已達流水*/
		FETCH NEXT FROM Cur INTO @CurRowNumber, @CurID, @CurAmount, @CurSumFlowAmount, @CurFlowAmountLImit, @CurFlowLimit
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--輸贏流水大於0才會做判斷
			IF @lngFlowAmount > 0
			BEGIN
				IF (@CurFlowLimit = 0)
					UPDATE Event.FlowAmountLimitLog SET StartTime = @Now, LastUpdateTime = @Now WHERE ID = @CurID

				IF ((@CurFlowAmountLImit - @CurFlowLimit) >= @lngFlowAmount)
				BEGIN
					--未通過
					SET @Amount = (@CurFlowLimit + @lngFlowAmount)
					SET @lngFlowAmount = 0
				END
				ELSE
				BEGIN
					--已通過
					IF (@CurRowNumber = 1)
						SET @Amount = (@CurFlowLimit + @lngFlowAmount)
					ELSE
						SET @Amount = @CurFlowAmountLImit
					SET @lngFlowAmount = (@lngFlowAmount - (@CurFlowAmountLImit - @CurFlowLimit))
					UPDATE Event.FlowAmountLimitLog SET EndTime = @Now, [Status] = 2, LastUpdateTime = @Now WHERE ID = @CurID
				END
				UPDATE Event.FlowAmountLimitLog SET FlowLimit = @Amount, LastUpdateTime = @Now WHERE ID = @CurID
			END
			
			FETCH NEXT FROM Cur INTO @CurRowNumber, @CurID, @CurAmount, @CurSumFlowAmount, @CurFlowAmountLImit, @CurFlowLimit
		END
	END
	ELSE
	BEGIN
		SELECT TOP 1 @CurID = ID, @CurFlowLimit = FlowLimit FROM Event.FlowAmountLimitLog WHERE UserID = @intUserID AND [Status] = 2 ORDER BY CreateTime DESC
		IF (@@ROWCOUNT > 0)
			UPDATE Event.FlowAmountLimitLog SET FlowLimit = (@CurFlowLimit + @lngFlowAmount), LastUpdateTime = @Now WHERE ID = @CurID
	END

	CLOSE Cur
	DEALLOCATE Cur

	RETURN 1
END