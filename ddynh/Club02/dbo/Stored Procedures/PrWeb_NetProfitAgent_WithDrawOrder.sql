-- =============================================
-- Author:  jason
-- Create date: 2019/04/15
-- Description: USER 提现(净利润)
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_NetProfitAgent_WithDrawOrder]
(
	@intUserID		int,	--用户 ID
	@intAmount		bigint,	--提现金额
	@chvMsg			varchar(100)	OUTPUT
)
AS
BEGIN

	set nocount on
	declare @intReturn	int

	exec @intReturn = [dbo].[PrPs_NetProfitAgent_WithDrawOrder]
		@intUserID	= @intUserID,	--用户 ID
		@intAmount	= @intAmount,	--提现金额
		@chvMsg	= @chvMsg	OUTPUT

	return @intReturn
END







