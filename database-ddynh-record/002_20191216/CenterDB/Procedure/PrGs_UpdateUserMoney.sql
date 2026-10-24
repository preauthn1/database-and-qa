USE [CenterDB]
GO

IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrGs_UpdateUserMoney')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrGs_UpdateUserMoney] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<更新用户金币>
--	2018-03-19	Jason			新增@StartStatTime , @EndStatTime做為取資料時使用
--	2018/04/12	Jason			原更新金幣統計有多個SP執行相同語法改為呼叫SP執行
-- 	2020/01/02 	Mars 			修改名詞: 现金 > 金币 #57
-- =============================================
ALTER PROCEDURE [dbo].[PrGs_UpdateUserMoney]
	@intMsgID			int,			--请求的消息ID(用于验证是否已经请求过)
	@intUserID			int,			--用户ID
	@lngUpdateAmount	bigint,			--变化数量
	@lngTaxAmount		bigint=null,	--税收数量
	@intServerID		int				--房间ID
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @NowTime		DATETIME = GETDATE()
	
	
	--如果消息已处理则直接返回
	--DECLARE @isMsgExists int
	--EXEC @isMsgExists = dbo.PrGs_CheckNetworkMsgIsExists @intServerID,@intMsgID
	--IF @isMsgExists = 1
	--BEGIN
	--	RETURN 1
	--END	
	
	
	
	IF @lngUpdateAmount<>0
	BEGIN
		DECLARE @bitIsRight BIT,@lngCurrentAmount BIGINT

		
		UPDATE Money.Cash
		SET @bitIsRight = CASE WHEN Amount + @lngUpdateAmount<0 THEN 0 ELSE 1 END
		,@lngCurrentAmount = Amount
		,Amount = CASE WHEN Amount + @lngUpdateAmount<0 THEN 0 ELSE Amount + @lngUpdateAmount END
		,Code = ''
		WHERE UserID = @intUserID
				
		IF @@ROWCOUNT>0 
		BEGIN		


			IF @bitIsRight = 0
			BEGIN 
				INSERT INTO Game.WarningLog
				(Memo, WriteTime)
				SELECT
				'金币不足, ' + CAST(@intUserID AS varchar)+',当前数量' + CAST(@lngCurrentAmount AS varchar) + ',更新数量' + CAST(@lngUpdateAmount AS VARCHAR),GETDATE()		
			END

		END
		ELSE
		BEGIN

			INSERT INTO Game.WarningLog
			(Memo, WriteTime)
			SELECT
			'更新了不存在的用户ID'+cast(@intUserID as varchar),GETDATE()		

		END
		
	
						
		/*  --更新金币统计  */
		------------------------------------------------------------------------------------------
		EXEC [dbo].[PrWeb_UpdateMoneySourceLog]
			@intUserID			= @intUserID,
			@intServerID		= @intServerID,
			@lngUpdateAmount	= @lngUpdateAmount,	
			@lngTaxAmount		= @lngTaxAmount,	
			@CreateTime			= @NowTime
		------------------------------------------------------------------------------------------

		
		--判断用户这一局赢的钱是否需要发全服公告
		IF @lngUpdateAmount>0 AND EXISTS(SELECT 1 FROM Game.WinAnnConfig where GameID in(select GameID from ServerInfo.GameServerList where ServerID=@intServerID) and UpperLimit<=@lngUpdateAmount) 
		BEGIN
			INSERT INTO Game.WinAnn(UserID,ServerID,WinAmount,Status,CreateTime)
			SELECT @intUserID,@intServerID,@lngUpdateAmount,0,GETDATE()
		END						
	END
	
END

GO