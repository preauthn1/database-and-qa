-- =============================================
-- Author:		Marshall
-- Create date: 2019/09/04
-- Description:	若資料不存在 重建
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Payment_CreatePlatformPayTypeSetting_IfNotExist]	
	@intPayTypeID INT = 0,		--PayTypeID
	@intPlatformID INT = 0,		--平台ID
	@resultID INT OUTPUT --錯誤訊息
AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetSettingID INT = 0;
	
	SELECT @TargetSettingID = ID 
	FROM Payment.PlatformPayTypeSetting 
	WHERE PlatformID = @intPlatformID AND PayTypeID = @intPayTypeID


	--檢查資料是否存在
	IF(NOT EXISTS(SELECT ID FROM Payment.PayType WHERE  ID = @intPayTypeID)) 
	BEGIN		
		SET @resultID = 0;
		RETURN @resultID;
	END



	IF (@TargetSettingID = 0 OR @TargetSettingID is NULL)
		BEGIN

			DECLARE @MinAmount int;
			DECLARE @MaxAmount int;
			DECLARE @AmountFixed bit;
			DECLARE @FixedAmount nvarchar(MAX);

			SELECT TOP 1
				
				@MinAmount=MinAmount , 		
				@MaxAmount=MaxAmount , 
				@AmountFixed=AmountFixed , 
				@FixedAmount=FixedAmount 

			FROM Payment.PayType
			WHERE ID = @intPayTypeID

			----首次建立 從payType那邊複製數值寫入
			INSERT INTO Payment.PlatformPayTypeSetting(PayTypeID, PlatformID, Status, CreateTime , [MinAmount] , [MaxAmount] ,[AmountFixed] ,[FixedAmount])
			VALUES(@intPayTypeID, @intPlatformID, 1, getDate(),@MinAmount ,@MaxAmount,@AmountFixed,@FixedAmount);

			IF (@@ROWCOUNT > 0)
			BEGIN

				SET @resultID = (SELECT CAST(SCOPE_IDENTITY() as int))
				RETURN @resultID

			END

		END
	ElSE
		BEGIN

			SET @resultID = @TargetSettingID
			RETURN @resultID

		END
	
END