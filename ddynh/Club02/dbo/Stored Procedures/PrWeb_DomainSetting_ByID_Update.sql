
-- =============================================
-- Author:		Amy
-- Create date: 2019-07-29
-- Description:	更改Domain使用ID查詢
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_DomainSetting_ByID_Update]
@intID	INT,					--平台ID
@chvDomain	VARCHAR(250) = '',		--平台Domain(網址或ip)
@chvMsg		VARCHAR(250) OUTPUT		--返回消息
AS
BEGIN

SELECT * FROM [Club02].[dbo].[DomainSetting] WHERE ID = @intID
IF(@@ROWCOUNT = 0)
BEGIN
SET @chvMsg	= '查無此筆資料，操作失敗'
RETURN -1
END

UPDATE [Club02].[dbo].[DomainSetting]
SET [Domain] = @chvDomain
WHERE ID = @intID

SET @chvMsg	= '操作成功'
RETURN 1
END