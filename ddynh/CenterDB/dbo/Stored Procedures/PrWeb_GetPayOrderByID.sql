-- =============================================
-- Author:		Mars
-- Create date: 2019/07/09
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.PrWeb_GetPayOrderByID
	@intOrderID int = 0,
	@chvRtnMsg varchar(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;

    SELECT ID,
			PayTypeID,
			UserID,
			Amount,
			Status,
			IPAddress,
			TransID,
			TransData,
			CreateTime,
			GWID
	FROM Pay.OrderList 
	WHERE Id = @intOrderID

	SET @chvRtnMsg = '';
	RETURN 1;
END