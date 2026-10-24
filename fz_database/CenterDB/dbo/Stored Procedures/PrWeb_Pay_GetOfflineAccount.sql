-- =============================================
-- Author:  CCC
-- Create date: 2019/08/03
-- Description: 線下帳戶查詢
-- Changelog:
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Pay_GetOfflineAccount]
(
	@intAdminID		INT,
	@intCompanyID	INT = NULL,
	@intTypeID		INT = NULL	--100:支付宝;200:微信;300:银行卡
)
AS
BEGIN

	SET NOCOUNT ON

	--營運商篩選
	DECLARE @Temp_Company TABLE (Company INT)

	
	INSERT INTO @Temp_Company 
	SELECT DISTINCT 
		   P.Company
      FROM CenterDB.Area.PlatformAdminUser as A WITH (NOLOCK)
      JOIN CenterDB.Area.[Platform] as P WITH (NOLOCK)
        ON A.PlatformID = P.PlatformID
	 WHERE AdminID=@intAdminId
	   

	
	SELECT O.Id,
		   O.TypeID,
		   O.RealName,
		   O.Account,
		   O.BankName,
		   O.Link,
		   O.MinGrade,
		   O.MaxGrade,
		   O.MinValue,
		   O.MaxValue,
		   O.Memo,
		   O.[Status],
		   O.Company,
		   CompanyName = P.[Name]
	  FROM [CenterDB].[Pay].[OfflineAccount] AS O WITH (NOLOCK)
	  JOIN @Temp_Company AS C ON O.Company = C.Company
	  JOIN [CenterDB].[Area].[Company] AS P WITH (NOLOCK)
	    ON C.Company = P.Id
	 WHERE (@intTypeID IS NULL OR O.TypeID = @intTypeID)
	   AND (@intCompanyID IS NULL OR C.Company = @intCompanyID)
	 ORDER BY O.Id DESC
END