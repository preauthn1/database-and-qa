-- =============================================
-- Author:  alan
-- Create date: 2018-3-14
-- Description:	获取銀聯卡銀行代號
--	2019/12/02	Mars			增加關聯UnionpayBankPlatformMapping, 可依平台選出相對應的銀聯代碼
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_GetUnionpayBankCode]
(
	@intUserID INT = NULL
)
AS
BEGIN
	SELECT B.Code, B.Bankname 
	FROM CenterDB.Money.UnionpayBankCode AS B WITH (NOLOCK)
	JOIN CenterDB.Money.UnionpayBankPlatformMapping AS M 
		ON B.Code = M.UnionpayBankCodeID 
		AND M.PlatformID IN (SELECT PlatformID FROM dbo.Fn_GetPlatformInfoByUserID(@intUserID))
	WHERE B.show = 1
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_GetUnionpayBankCode] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_GetUnionpayBankCode] TO [xbuser]
    AS [dbo];

