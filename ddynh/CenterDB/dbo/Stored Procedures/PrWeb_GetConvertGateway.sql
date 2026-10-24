
-- =============================================
-- Author:  Marshall
-- Create date: 2019-12-02
-- Description:	获取代付廠商
--	2019/12/02	Mars			增加關聯Pay.ConvertGatewayBankSetting/Money.UnionpayBankPlatformMapping取得該筆兌換當時所能選擇的代付渠道
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetConvertGateway]	
(
	@intAdminId INT,
	@intUserId INT = NULL,
	@intConvertType INT = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT DISTINCT G.[ID],
           G.[GatewayName],
           G.[ConvertType],
           G.[Status],
		   1 as Company
     FROM [CenterDB].[Pay].[ConvertGateway] AS G WITH (NOLOCK) 
	 JOIN [CenterDB].[Pay].[ConvertGatewayBankSetting] AS S ON S.ConvertGatewayID = G.ID AND S.Status = 1 
	 JOIN [CenterDB].[Money].[UnionpayBankPlatformMapping] AS M 
		ON M.UnionpayBankCodeID = S.UnionpayBankCodeID 
		AND M.PlatformID IN (SELECT PlatformID FROM dbo.Fn_GetPlatformInfoByUserID(@intUserId))
     WHERE G.Status = 1 AND G.ConvertType = @intConvertType

END