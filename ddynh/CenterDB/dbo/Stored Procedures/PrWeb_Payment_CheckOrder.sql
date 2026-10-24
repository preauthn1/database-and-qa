-- =============================================
-- Author:  Mars
-- Create date: 2019/09/17
-- Description:	<檢查訂單>
-- 2019/10/01	Mars	查同GWID時，排除同ID
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_CheckOrder]
(
	@intOrderID			INT,					--订单号
	@chvTransID			VARCHAR(50) = NULL,		--交易标识
	@chvRtnMsg			VARCHAR(200) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	Declare @GWID INT,
			@PayTypeID INT,
			@Status INT,
			@TransID VARCHAR(50)

	--查出訂單資訊
	SELECT @GWID = GWID, @PayTypeID = PayTypeID, @Status = [Status], @TransID = TransID 
	FROM Pay.OrderList 
	WHERE Id = @intOrderID;

	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @chvRtnMsg = '查无订单';
		RETURN 1
	END

	--檢查同Payment Gateway是否有相同交易标识
	IF (@chvTransID IS NOT NULL)
	BEGIN
		SELECT ID 
		FROM Pay.OrderList 
		WHERE GWID = @GWID 
			AND TransID = @chvTransID 
			AND Id <> @intOrderID
			
		IF (@@ROWCOUNT > 0)
		BEGIN
			SET @chvRtnMsg = '交易标识已存在';
			RETURN -1
		END
	END

	RETURN 1;

END

