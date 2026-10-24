
-- =============================================
-- Author:  Mars
-- Create date: 2019/11/22
-- Description:	Poker非連線型Jackpot計算紀錄
--	2019/11/27	Mars			修正@lngJackpotPool的值為累加
--	2019/11/27	Mars			修正update時各值為分別辨斷是否為0
-- =============================================
CREATE PROCEDURE [dbo].[PrGs_Poker_JackpotPool_NoLink]
	@intGameID				INT,			--Game ID
	@intFlagID				INT,			--Flag ID
	@intTableNo				INT,			--桌子編號
	@intLevelID				INT,			-- level id
	@lngContribution		BIGINT = NULL,	--玩家貢獻值
	@lngTotalContribution	BIGINT = NULL,	--累積貢獻值
	@lngAwardTotal			BIGINT = NULL,	--已發送獎金總和
	@lngJackpotPool			BIGINT = NULL,	--彩池金額
	@chvMsg					VARCHAR(100) OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @Temp_Table TABLE ([GameID] INT,[FlagID] INT,[TableNo] INT,[LevelID] INT,[Contribution] BIGINT,[TotalContribution] BIGINT,[AwardTotal] BIGINT,
								[JackpotPool] BIGINT)

	SET @lngContribution = ISNULL(@lngContribution,0)
	SET @lngTotalContribution = ISNULL(@lngTotalContribution,0)
	SET @lngAwardTotal = ISNULL(@lngAwardTotal,0)
	SET @lngJackpotPool = ISNULL(@lngJackpotPool,0)

	IF NOT EXISTS (SELECT TOP 1 1 FROM [ServerInfo].[GameServerList] WITH (NOLOCK) WHERE [GameID] = @intGameID AND [ShowName] = @intFlagID)
	BEGIN
		SET @chvMsg = '操作失敗 :  查無此服務器'
		RETURN -1
	END

	IF NOT EXISTS (SELECT TOP 1 1 FROM [Game].[Poker_JackpotPool_NoLink] WITH (NOLOCK) WHERE [GameID] = @intGameID AND [FlagID] = @intFlagID AND [TableNo] = @intTableNo AND [LevelID] = @intLevelID)
	BEGIN
		INSERT INTO [Game].[Poker_JackpotPool_NoLink]
			([GameID],[FlagID],[TableNo],[LevelID],[Contribution],[TotalContribution],[AwardTotal],[JackpotPool])
		VALUES
			(@intGameID,@intFlagID,@intTableNo,@intLevelID,@lngContribution,@lngTotalContribution,@lngAwardTotal,@lngJackpotPool)

		IF(@@ROWCOUNT <> 1)
		BEGIN
			SET @chvMsg = '操作失敗 : 新增記錄失敗'
			RETURN -1
		END
		ELSE
		BEGIN

			SELECT	@intGameID AS [GameID],
					@intFlagID AS [FlagID],
					@intTableNo AS [TableNo],
					@intLevelID AS [LevelID],
					@lngContribution AS [Contribution],
					@lngTotalContribution AS [TotalContribution],
					@lngAwardTotal AS [AwardTotal],
					@lngJackpotPool AS [JackpotPool]

			SET @chvMsg = '操作完成'
			RETURN 1
		END
	END

	
	IF(@lngContribution <> 0 OR @lngTotalContribution <> 0 OR @lngAwardTotal <> 0 OR @lngJackpotPool <> 0)
	BEGIN
		UPDATE [Game].[Poker_JackpotPool_NoLink]
		SET [Contribution] = [Contribution] + @lngContribution,
			[TotalContribution] = [TotalContribution] + @lngTotalContribution,
			[AwardTotal] = [AwardTotal] + @lngAwardTotal,
			[JackpotPool] = [JackpotPool] + @lngJackpotPool
		OUTPUT INSERTED.[GameID],INSERTED.[FlagID],INSERTED.[TableNo],INSERTED.[LevelID],INSERTED.[Contribution],INSERTED.[TotalContribution],INSERTED.[AwardTotal],INSERTED.[JackpotPool] INTO @Temp_Table
		WHERE
			[GameID] = @intGameID
			AND [FlagID] = @intFlagID
			AND [TableNo] = @intTableNo
			AND [LevelID] = @intLevelID
	END
	ELSE
	BEGIN
		INSERT INTO @Temp_Table
		SELECT	[GameID],
				[FlagID],
				[TableNo],
				[LevelID],
				[Contribution],
				[TotalContribution],
				[AwardTotal],
				[JackpotPool]
		FROM [Game].[Poker_JackpotPool_NoLink] WITH (NOLOCK)
		WHERE
			[GameID] = @intGameID
			AND [FlagID] = @intFlagID
			AND [TableNo] = @intTableNo
	END


	IF NOT EXISTS (SELECT TOP 1 1 FROM @Temp_Table WHERE [GameID] = @intGameID AND [FlagID] = @intFlagID AND [TableNo] = @intTableNo AND [LevelID] = @intLevelID)
	BEGIN
		SET @chvMsg = '操作失敗 : 查無紀錄'
		RETURN -1
	END

	SELECT	[GameID],
			[FlagID],
			[TableNo],
			[LevelID],
			[Contribution],
			[TotalContribution],
			[AwardTotal],
			[JackpotPool] 
	FROM @Temp_Table AS A
	WHERE
		A.[GameID] = @intGameID
		AND A.[FlagID] = @intFlagID
		AND A.[TableNo] = @intTableNo
	UNION ALL
	SELECT	[GameID],
			[FlagID],
			[TableNo],
			[LevelID],
			[Contribution],
			[TotalContribution],
			[AwardTotal],
			[JackpotPool]
	FROM [Game].[Poker_JackpotPool_NoLink] WITH (NOLOCK)
	WHERE
		[GameID] = @intGameID
		AND [FlagID] = @intFlagID
		AND [TableNo] = @intTableNo
		AND LevelID NOT IN (SELECT LevelID FROM @Temp_Table)


	SET @chvMsg = '操作成功'
	
	RETURN 1	
	
	
END