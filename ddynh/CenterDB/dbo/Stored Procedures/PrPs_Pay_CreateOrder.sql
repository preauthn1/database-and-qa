-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<客户端创建充值订单>
-- Changelog:
--		20180905	alan	增加預先寫入@chvTransID, 支持統一支付久聊代理充值
--		20190809	Rory	通道隨機挑選可用的支付商, 使用權重隨機法
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Pay_CreateOrder]
@intPayTypeID	int,				--充值类型
@intUserID		INT,				--用户ID
@lngAmount		bigint,				--充值金额
@chvIPAddress	varchar(15),		--IP地址
@chvTransID		varchar(32)=null,	--第三方标识
@intOrderID		int output,			--订单号
@chvErrMsg		varchar(128) OUTPUT	--返回消息
AS
SET NOCOUNT ON

DECLARE @intAmountCent BIGINT
DECLARE @retIntGWID BIGINT
DECLARE @retIntTypeID BIGINT
DECLARE @intPlatformID INT

SET @intAmountCent = @lngAmount * 100
SELECT @intPlatformID = b.PlatformID FROM Users.UserInfo AS a LEFT JOIN Area.Area AS b ON a.AreaID = b.AreaID WHERE a.UserID = @intUserID

EXEC [dbo].[PrPr_RndPayGateway]
		@intTypeID = @intPayTypeID,
		@intPlatformID = @intPlatformID,
		@intAmount = @intAmountCent,
		@retIntGWID = @retIntGWID OUTPUT,
		@retIntTypeID = @retIntTypeID OUTPUT

declare @intReturn int
exec @intReturn = dbo.PrWeb_Pay_CreateOrder
@intPayTypeID = @retIntTypeID,
@intUserID = @intUserID,
@lngAmount = @lngAmount,
@chvIPAddress = @chvIPAddress,
@chvTransID = @chvTransID,
@chvTransData = '客户端',
@intOrderID = @intOrderID output,
@chvErrMsg = @chvErrMsg output

RETURN @intReturn

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Pay_CreateOrder] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Pay_CreateOrder] TO [xbuser]
    AS [dbo];

