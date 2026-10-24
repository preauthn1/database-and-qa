-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<客户端创建充值订单>
-- Changelog:
--		20180905	alan	增加預先寫入@chvTransID, 支持統一支付久聊代理充值
--		20190807	CCC		增加線下充值
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_Pay_CreateOrder]
@intPayTypeID	int,				--充值类型
@intUserID		INT,				--用户ID
@lngAmount		bigint,				--充值金额
@chvIPAddress	varchar(15),		--IP地址
@chvTransID		varchar(32)=null,	--第三方标识
@intAccountID	INT=null,			--線下帳戶ID
@chvPayer		varchar(64)=null,	--付款人資訊
@intOrderID		int output,			--订单号
@chvErrMsg		varchar(128) OUTPUT	--返回消息
AS
SET NOCOUNT ON

declare @chvRealName	VARCHAR(64)	--收款人
declare @chvAccount		VARCHAR(64)	--收款帳號
declare @chvBankName	VARCHAR(50)	--收款帳戶
declare @intPlatformID	INT			--平台
declare @intAreaID		INT			--渠道
declare @tnyGatewayID	TINYINT		--支付第三方
declare @intReturn		INT

IF @intAccountID IS NOT NULL
BEGIN

	IF @chvPayer IS NULL
	BEGIN
		SET @chvErrMsg = '付款人不正确'	
		RETURN -1
	END

	SELECT @chvRealName = [RealName],
		   @chvAccount = [Account],
		   @chvBankName =[BankName]       
	  FROM [CenterDB].[Pay].[OfflineAccount] WITH (NOLOCK)
	 WHERE Id = @intAccountID

	IF @chvAccount IS NULL
	BEGIN
		SET @chvErrMsg = '線下帳戶不正确'		
		RETURN -1
	END

	SELECT @intPlatformID = A.PlatformID,
		   @intAreaID =  A.AreaID
	  FROM [CenterDB].[Users].[UserInfo] AS U WITH (NOLOCK)
	  JOIN [CenterDB].[Area].[Area] AS A WITH (NOLOCK)
		ON U.AreaID = A.AreaID
	 WHERE U.UserID = @intUserID

	SELECT TOP (1) 
		   @tnyGatewayID = [GWID]
	  FROM [CenterDB].[Pay].[UnionPlatformPayType]
	 WHERE [TypeID] = @intPayTypeID
		AND PlatformID = @intPlatformID

	IF @tnyGatewayID IS NULL
	BEGIN
		SET @chvErrMsg = '支付渠道无效'		
		RETURN -1
	END
END

BEGIN TRAN

exec @intReturn = dbo.PrWeb_Pay_CreateOrder
	@intPayTypeID = @intPayTypeID,
	@intUserID = @intUserID,
	@lngAmount = @lngAmount,
	@chvIPAddress = @chvIPAddress,
	@chvTransID = @chvTransID,
	@tnyGatewayID = @tnyGatewayID,
	@chvTransData = '客户端',
	@intOrderID = @intOrderID output,
	@chvErrMsg = @chvErrMsg output

IF @intReturn <> 1
BEGIN
	ROLLBACK
	RETURN @intReturn
END

IF @intAccountID IS NOT NULL
BEGIN	

	INSERT INTO [CenterDB].[Pay].[OfflineOrder]
		(
		   [UserID]
		  ,[Payer]
		  ,[Amount]
		  ,[TypeID]
		  ,[RealName]
		  ,[Account]
		  ,[BankName]
		  ,[Memo]
		  ,[Operator]
		  ,[OrderID]
		  ,[PlatformID]
		  ,[AreaID]
		  ,[Status]
		  ,[CreateTime]
		  ,[LastUpdateTime]
		)
	SELECT @intUserID
		  ,@chvPayer
		  ,@lngAmount
		  ,@intPayTypeID
		  ,@chvRealName
		  ,@chvAccount
		  ,@chvBankName
		  ,[Memo] = NULL
		  ,[Operator] = NULL
		  ,[OrderID] = @intOrderID
		  ,[PlatformID] = @intPlatformID
		  ,[AreaID] = @intAreaID
		  ,[Status] = 0
		  ,[CreateTime] = GETDATE()
		  ,[LastUpdateTime] = GETDATE()

	IF @@ROWCOUNT <> 1
	BEGIN
		ROLLBACK
		SET @chvErrMsg = '操作失败'
		RETURN -1
	END
END

COMMIT

RETURN 1
