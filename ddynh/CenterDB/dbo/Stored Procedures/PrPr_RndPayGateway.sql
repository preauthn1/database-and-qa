
-- =============================================
-- Author:  Rory
-- Create date: 2019-08-06
-- Description:	隨機挑選支付渠道
-- =============================================

CREATE PROCEDURE [dbo].[PrPr_RndPayGateway]	
@intTypeID INT,
@intPlatformID INT,
@intAmount BIGINT,
@retIntGWID INT OUTPUT,
@retIntTypeID INT OUTPUT
AS
BEGIN
	SELECT * INTO #temp_table 
	FROM ( 
			SELECT  
			    setting.ID as SettingID,
				payType.GWID,
				b.TypeID,
				TypeName = b.BankName + ' (' + payType.BankCode + ')',
				PayTypeID = payType.ID,
				b.SourceTypeID,
				AmountSort = 
					CASE WHEN ISNULL(setting.AmountFixed, payType.amountFixed) = 1 
					THEN ISNULL(setting.FixedAmount, payType.fixedAmount) 
					ELSE ISNULL(payType.fixedAmount, '10000,20000,30000,50000,60000,80000,90000,100000') 
					END,

				IsRange = 
					CASE WHEN ISNULL(setting.AmountFixed, payType.amountFixed) = 1 
					THEN 0 
					ELSE 1 
					END,

				MinValue = ISNULL(dbo.Fn_PaymentMinAmount(setting.MinAmount, setting.AmountFixed, setting.FixedAmount),dbo.Fn_PaymentMinAmount(payType.minAmount, payType.amountFixed, payType.fixedAmount)),
				MaxValue = 				
					CASE WHEN ISNULL(setting.MaxAmount, payType.maxAmount) <> 0 
					THEN ISNULL(setting.MaxAmount, payType.maxAmount)
					ELSE 100000000 
					END,

				RWeight = ISNULL(setting.Priority, 1), --權重
				Status = CASE WHEN setting.status is null THEN 0 ELSE setting.status END

			FROM [Payment].[PayType] AS payType 
			JOIN [Payment].[BankCodeType] AS b ON payType.BankCode = b.BankCode
			JOIN [Payment].[PayGateway] AS c ON payType.GWID = c.ID and c.status = 1 
			LEFT JOIN [Payment].[PlatformPayTypeSetting] AS setting ON setting.PayTypeID = payType.id and setting.PlatformID = @intPlatformID
			JOIN [Payment].[MerchantInfo] AS e ON c.ID = e.GWID AND e.Status = 1 
			WHERE payType.Type = 1 AND payType.status = 1 AND setting.status = 1 AND e.PlatformID = @intPlatformID 

		) as tmp


	DECLARE @intGWID BIGINT
	DECLARE @intPayTypeID BIGINT
	DECLARE @intRWeight BIGINT
	DECLARE @chvAmountSort VARCHAR(255)
	
	--符合條件
	DECLARE @hitTable TABLE (GWID INT, TypeID INT, RWeight INT)
	DECLARE @ttlWeight BIGINT

	--支付寶固額
	IF @intTypeID = 12
	BEGIN
		DECLARE MyCursor Cursor FOR --宣告，名稱為MyCursor

		SELECT GWID, PayTypeID, AmountSort, RWeight 
		FROM #temp_table 
		WHERE TypeID IN (1, 11) AND IsRange = 0 
		ORDER BY newid()

		Open MyCursor
			Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @intRWeight
			While (@@FETCH_STATUS <> -1)
				BEGIN
					IF EXISTS (SELECT [Value] FROM [dbo].[fn_Split2](@chvAmountSort, ',') WHERE [Value] = @intAmount)
					BEGIN
						SELECT @ttlWeight = Max(RWeight) FROM @hitTable
						INSERT INTO @hitTable VALUES(@intGWID, @intPayTypeID, ISNULL(@ttlWeight, 0) + @intRWeight)
					END
					Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @intRWeight
				END
		CLOSE MyCursor

		DEALLOCATE MyCursor
		SELECT @ttlWeight = Max(RWeight) FROM @hitTable
		SELECT TOP(1) @retIntGWID = GWID, @retIntTypeID = TypeID FROM @hitTable WHERE RWeight >= FLOOR( RAND(CAST(NEWID() AS VARBINARY)) * @ttlWeight ) ORDER BY RWeight ASC
		RETURN
	END


	--支付寶
	IF @intTypeID = 1
	BEGIN
		INSERT INTO @hitTable
		SELECT GWID, PayTypeID, SUM(RWeight) over(ORDER BY PayTypeID) FROM #temp_table 
		WHERE TypeID IN (1, 11) AND IsRange = 1 AND MinValue <= @intAmount AND MaxValue >= @intAmount ORDER BY PayTypeID
		--select * from @hitTable
		SELECT @ttlWeight = Max(RWeight) FROM @hitTable
		SELECT TOP(1) @retIntGWID = GWID, @retIntTypeID = TypeID FROM @hitTable WHERE RWeight >= FLOOR( RAND(CAST(NEWID() AS VARBINARY)) * @ttlWeight ) ORDER BY RWeight ASC
		RETURN
	END


	--微信固額
	IF @intTypeID = 22
	BEGIN
		DECLARE MyCursor Cursor FOR --宣告，名稱為MyCursor
		SELECT GWID, PayTypeID, AmountSort, RWeight FROM #temp_table WHERE TypeID IN (2, 21) AND IsRange = 0 ORDER BY newid()
				
		Open MyCursor

			Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @intRWeight
			While (@@FETCH_STATUS <> -1)
				BEGIN
					IF EXISTS (SELECT [Value] FROM [dbo].[fn_Split2](@chvAmountSort, ',') WHERE [Value] = @intAmount)
					BEGIN
						SELECT @ttlWeight = Max(RWeight) FROM @hitTable
						INSERT INTO @hitTable VALUES(@intGWID, @intPayTypeID, ISNULL(@ttlWeight, 0) + @intRWeight)
					END
					Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @intRWeight
				END
		CLOSE MyCursor

		DEALLOCATE MyCursor
		SELECT @ttlWeight = Max(RWeight) FROM @hitTable
		SELECT TOP(1) @retIntGWID = GWID, @retIntTypeID = TypeID FROM @hitTable WHERE RWeight >= FLOOR( RAND(CAST(NEWID() AS VARBINARY)) * @ttlWeight ) ORDER BY RWeight ASC
		RETURN
	END


	--微信
	IF @intTypeID = 2
	BEGIN
		INSERT INTO @hitTable
		SELECT GWID, PayTypeID, SUM(RWeight) over(ORDER BY PayTypeID) FROM #temp_table 
		WHERE TypeID IN (2, 21) AND IsRange = 1 AND MinValue <= @intAmount AND MaxValue >= @intAmount ORDER BY PayTypeID

		SELECT @ttlWeight = Max(RWeight) FROM @hitTable
		SELECT TOP(1) @retIntGWID = GWID, @retIntTypeID = TypeID FROM @hitTable WHERE RWeight >= FLOOR( RAND(CAST(NEWID() AS VARBINARY)) * @ttlWeight ) ORDER BY RWeight ASC
		RETURN
	END


	--其他支付
	DECLARE @isRange BIT
	DECLARE MyCursor Cursor FOR --宣告，名稱為MyCursor

	SELECT GWID, PayTypeID, AmountSort, IsRange, RWeight 
	FROM #temp_table 
	WHERE TypeID = @intTypeID AND ((MinValue <= @intAmount AND MaxValue >= @intAmount) OR IsRange = 0)
	
	-- Cursor迴圈
	Open MyCursor

		Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @isRange, @intRWeight

		While (@@FETCH_STATUS <> -1)
			BEGIN
				IF (@isRange = 0 AND EXISTS (SELECT [Value] FROM [dbo].[fn_Split2](@chvAmountSort, ',') WHERE [Value] = @intAmount)) OR @isRange = 1
				BEGIN
					SELECT @ttlWeight = Max(RWeight) FROM @hitTable
					INSERT INTO @hitTable VALUES(@intGWID, @intPayTypeID, ISNULL(@ttlWeight, 0) + @intRWeight)
				END
				Fetch NEXT FROM MyCursor INTO @intGWID, @intPayTypeID, @chvAmountSort, @isRange, @intRWeight
			END

	CLOSE MyCursor
	DEALLOCATE MyCursor

	SELECT * FROM @hitTable
	SELECT @ttlWeight = Max(RWeight) FROM @hitTable

	SELECT TOP(1) @retIntGWID = GWID, @retIntTypeID = TypeID 
	FROM @hitTable 
	WHERE RWeight >= FLOOR( RAND(CAST(NEWID() AS VARBINARY)) * @ttlWeight ) 
	ORDER BY RWeight ASC

	RETURN
END