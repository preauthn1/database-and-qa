
-- =============================================
-- Author:  Mars
-- Create date: 2019/09/26
-- Description:	將GWID補齊
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Payment_CheckPayOrderListGWID]

AS
SET NOCOUNT ON
BEGIN
	DECLARE @rowNum int = 0, 
			@Id int,
			@payTypeId int,
			@gwId int
	
	--撈出未寫入GWID的筆數
	SELECT @rowNum = count(*) FROM Pay.OrderList WHERE GWID is null
	IF (@rownum > 0)
	BEGIN
		DECLARE cur CURSOR FOR
			SELECT Id, PayTypeID FROM Pay.OrderList WHERE GWID is null
		OPEN cur
		FETCH NEXT FROM cur INTO @Id, @payTypeId
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--查詢GWID
			SELECT @gwId = GWID FROM Payment.PayType WHERE Id = @payTypeId
	
			--寫入GWID
			UPDATE Pay.OrderList SET GWID = @gwId WHERE ID = @Id AND GWID IS NULL
	
			FETCH NEXT FROM cur INTO @Id, @payTypeId
		END
		CLOSE cur
		DEALLOCATE cur
	END

    RETURN 1
END