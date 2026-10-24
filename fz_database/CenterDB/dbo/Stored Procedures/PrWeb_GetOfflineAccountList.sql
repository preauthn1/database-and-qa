-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	获取線下支付清單
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetOfflineAccountList]	
@intPlatformID		INT=NULL
AS
BEGIN

	DECLARE @UnionnPlatform TABLE (PlatformID int,GWID int,TypeID int,[Status] tinyint)

	INSERT INTO @UnionnPlatform 
	SELECT PlatformID,GWID,TypeID,[Status]
	  FROM [CenterDB].[Pay].[UnionPlatformPayType] with (nolock) 
 	 WHERE PlatformID = @intPlatformID
	   AND TypeID IN (100,200,300)
	   AND Status = 1	

	SELECT O.Id,
		   P.GWID, 
		   G.GatewayName,
		   P.TypeID, 
		   T.TypeName, 
		   O.RealName,
		   O.Account,
		   O.BankName,
		   O.Link,
		   O.MinGrade, 
		   O.MaxGrade, 		 
		   O.MinValue, 
		   O.MaxValue,
		   O.Status
	  FROM @UnionnPlatform as P
	  JOIN [CenterDB].[Area].[Platform] as C on P.PlatformID = C.PlatformID 
	  JOIN [CenterDB].[Pay].[OfflineAccount] as O on C.Company = O.Company AND P.TypeID = O.TypeID
	  LEFT JOIN [CenterDB].[Pay].[PayGateway] as G on P.GWID= G.ID		
	  LEFT JOIN [CenterDB].[Pay].[PayType] AS T on T.GWID = P.GWID and T.TypeID = P.TypeID
	 WHERE O.Status = 1	 
END
