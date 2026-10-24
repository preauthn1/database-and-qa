
-- =============================================
-- Author:		Mars
-- Create date: 2019/07/08
-- Description:	<Description,,>
-- 2019/07/17	Mars	支援platform
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetMerchantUuid]
	@intPayTypeID int,
	@intPlatformID int,
	@chvRtnMsg varchar(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN

	SET NOCOUNT ON;

	SELECT T.ID, M.GWID, T.BankCode, T.Currencies, M.uuid, G.Systems, G.Url, M.InfoData 
	FROM payment.PayType AS T 
	JOIN payment.PayGateway AS G ON G.ID = T.GWID AND G.Status = 1 
	JOIN payment.merchantInfo AS M ON M.GWID = G.ID AND M.Status = 1 AND M.PlatformID = @intPlatformID 
	JOIN Payment.BankCodeType AS B ON  B.BankCode = T.BankCode 
	WHERE T.ID = @intPayTypeID;

	SET @chvRtnMsg = '';
	RETURN 1;
END