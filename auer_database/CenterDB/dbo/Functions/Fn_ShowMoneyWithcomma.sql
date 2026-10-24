-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<获取金币金额显示>
-- =============================================
CREATE FUNCTION [dbo].[Fn_ShowMoneyWithcomma]
(
	@lngAmount			bigint	--金币数
)
RETURNS varchar(32)
AS
BEGIN
	--return cast(@lngAmount as varchar(32))
	declare @dmlMoney decimal(18,2)	,@chvMoney varchar(32)
	SET @dmlMoney= @lngAmount*1.0/100
	IF @dmlMoney%1=0
	begin
		SET @chvMoney = cast(CAST(@dmlMoney as decimal(18,0)) as varchar)
	END
	ELSE IF @dmlMoney%0.1=0
	BEGIN
		SET @chvMoney = cast(CAST(@dmlMoney as decimal(18,1)) as varchar)
	END
	ELSE
	BEGIN
		SET @chvMoney = cast(@dmlMoney  as varchar)
	end
	RETURN REPLACE(CONVERT(VARCHAR,CONVERT(MONEY, (CASE
		WHEN
		(isnumeric(@dmlMoney) = 1) 
	THEN
		CAST(@dmlMoney AS bigint)
	ELSE
		0
	END)),1), '.00','')
END