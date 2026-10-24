
-- =============================================
-- Author:		Mars
-- Create date: 2019/07/07
-- Description:	取得商戶號渠道設定
--	2019/11/06	Mars			增加gwid #204
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetMerchantList] 
	@intGWID int = NULL,
	@chvGWCode varchar(50) = null,
	@intAdminID int = 0,
	@intPlatformID int = null,
	@intId		int = 0,
	@chvRtnMsg	varchar(50) = '' OUTPUT	--錯誤訊息
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @GWID int = null,
			@GWName varchar(50),
			@GWInfo int = 0;

	--查單筆
	IF (@intId > 0)
	BEGIN
		SELECT @GWName as GWName, @GWID as GWID, @GWInfo as Info, M.ID, M.InfoData, M.uuid, M.MerchantStatus, M.Status, P.Name AS PlatformName 
		FROM Payment.MerchantInfo AS M 
		JOIN AREA.Platform P ON P.PlatformID = M.PlatformID 
		WHERE M.ID = @intId;

		SET @chvRtnMsg = ''
		RETURN 1
	END

	IF (@intGWID IS NOT NULL)
	BEGIN
		SELECT @GWName = GatewayName, @GWInfo = MerchantInfo FROM Payment.PayGateway WHERE ID = @intGWID
		SET @GWID = @intGWID
	END
	ELSE
	BEGIN
		SELECT @GWID = ID, @GWName = GatewayName, @GWInfo = MerchantInfo FROM Payment.PayGateway WHERE GatewayCode = @chvGWCode
	END

	IF @@ROWCOUNT = 0
	BEGIN 
		SET @chvRtnMsg = '查無資料'
		RETURN -1
	END
	
	SELECT * INTO #Temp_AccessRights FROM dbo.Fn_GetAdminAccessRights(@intAdminID)

	SELECT A.* FROM ( 
		SELECT @GWName as GWName, @GWID as GWID, @GWInfo as Info, M.ID, M.InfoData, M.uuid, M.MerchantStatus, M.Status, P.PlatformID, P.Name AS PlatformName 
		FROM Payment.MerchantInfo AS M 
		JOIN AREA.Platform P ON P.PlatformID = M.PlatformID 
		WHERE GWID = @GWID
		AND (@intPlatformID IS NULL OR M.PlatformID = @intPlatformID)
	) AS A 
	join (SELECT PlatformID FROM #Temp_AccessRights GROUP BY PlatformID) AS B  ON B.PlatformID = A.PlatformID

	SET @chvRtnMsg = ''
	RETURN 1
END