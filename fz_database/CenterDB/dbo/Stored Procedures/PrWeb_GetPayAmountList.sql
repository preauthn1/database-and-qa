-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	获取支付金额接口
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPayAmountList]	
@intPlatformID		INT=NULL
AS
BEGIN

	DECLARE @UnionnPlatform TABLE (PlatformID int,GWID int,TypeID int,[Status] tinyint, Company int)

	INSERT INTO @UnionnPlatform 
	SELECT U.PlatformID, U.GWID, U.TypeID, U.[Status], C.Company
	FROM [CenterDB].[Pay].[UnionPlatformPayType] as U with (nolock) 
	 JOIN [CenterDB].[Area].[Platform] as C with (nolock)  on U.PlatformID = C.PlatformID 
	WHERE U.PlatformID = @intPlatformID
	AND Status = 1	
	AND U.TypeID NOT IN (100,200,300)	--线下支付
	
	SELECT T.GWID, 
		   T.TypeID, 
		   T.TypeName, 
		   T.TradeCode, 
		   T.SourceTypeID, 
		   T.Scale, 
		   T.[Status],
		   T.AmountSort, 
		   T.IsRange,
		   G.MinGrade, 
		   G.MaxGrade, 	
		   T.MinValue, 
		   T.MaxValue,		   
		   G.GatewayName,
		   Popular = CAST(0 as tinyint),
		   Sort = 0,
		   Priority
	FROM @UnionnPlatform as P
	JOIN [CenterDB].[Pay].[PayType] AS T on T.GWID = P.GWID and T.TypeID = P.TypeID
	LEFT JOIN [CenterDB].[Pay].[PayGateway] as G on T.GWID= G.ID	
	WHERE T.Status = 1
END
