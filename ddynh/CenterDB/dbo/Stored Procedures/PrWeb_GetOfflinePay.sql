-- =============================================
-- Author:  Mars
-- Create date: 2019/08/26
-- Description:	查询線下支付
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetOfflinePay]
(
	@intGWID		INT OUTPUT,
	@intPayTypeID	INT OUTPUT,
	@chvRtnMsg		VARCHAR(200) OUTPUT	--记录总数		
)
AS
BEGIN
	SELECT @intGWID = G.ID,  @intPayTypeID = P.ID
	FROM Payment.PayGateway AS G
	JOIN Payment.PayType AS P ON G.ID = P.GWID
	WHERE GatewayCode = 'OFFLINEPAY'

	SET @chvRtnMsg = '查詢成功'
	RETURN 1
END