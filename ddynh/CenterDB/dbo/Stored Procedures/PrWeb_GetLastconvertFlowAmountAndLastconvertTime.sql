-- =============================================
-- Author:		Amy
-- Create date: 2019-08-02
-- Description:	UserInfo/Search (稽核流水欄位)以及 大厅登录_登录公用逻辑(一倍流水限制) 中，LastconvertFlowAmount 和 LastconvertFlowAmountLimit 兩個欄位

-- 2019-08-20	Amy			稽核流水欄位的流水限額改讀其他資料來源，原先LastconvertFlowAmountLimit仍供一倍流水欄位使用(不刪除)
-- 2019-08-27	Mars		充值一倍流水排除線下支付
-- 2019-09-12	Mars		更改輸贏流水計算為每筆稽核, 不應累計
-- 2019-10-31	Marshall	調整狀態999的一些case when語法
-- 2019-11-27	Marshall	@intLastconvertFlowAmountLimit 已廢棄

-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetLastconvertFlowAmountAndLastconvertTime]
@intUserID INT,
@intLastconvertFlowDiff INT = 0				OUTPUT,	--從最後一次提領到現在遊戲輸贏的流水(預設總流水 - 上次提領時的流水)
@intLastconvertFlowAmountLimit INT = 0		OUTPUT,	--此欄位已刪除、沒有意義
@intSumFlowAmountLimit INT = 0				OUTPUT,	--從最後一次提領到現在的稽核流水限額
@dateLastConvertTime DATETIME				OUTPUT,	--最後一次提款的放款時間
@dateNOW DATETIME							OUTPUT	--目前的時間

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NowSumFlowAmount BIGINT = 0,
			@SumFlowAmount BIGINT,
			@FlowAmountLimit BIGINT = 0,
			@LastFlowLimit BIGINT = 0,
			@LastconvertFlowAmount BIGINT

	--內部預設
	SET @dateNOW = GETDATE();

	--抓取最後一次提領紀錄的放款時間BEGIN
	SELECT TOP 1 @dateLastConvertTime = CreateTime
	FROM [LogDB].[Money].[ConvertLog]
	WHERE [UserID] = @intUserID
		AND Status = 3 
	ORDER BY ID DESC


	--如果沒有提領紀錄就抓取註冊時間
	IF (@@ROWCOUNT = 0)
		SELECT @dateLastConvertTime = [CreateTime] 
		FROM [CenterDB].[Users].[UserInfo] 
		WHERE UserID = @intUserID


	--抓取從最後一次提領到現在遊戲輸贏的流水
	SELECT @intLastconvertFlowDiff = ( SumFlowAmount - LastconvertFlowAmount),  
			@LastconvertFlowAmount = LastconvertFlowAmount,
			@NowSumFlowAmount = SumFlowAmount
	FROM [CenterDB].[Users].[UserInfo] WHERE UserID = @intUserID
	
	
	
	--取得稽核流水未通過的紀錄	
	SELECT @intSumFlowAmountLimit = SUM
			(
				--如果狀態是已刪除的稽核流水，強制視為0元
				CASE WHEN F.Status = 999 THEN 0
				ELSE F.FlowAmountLimit END
			), 
			@intLastconvertFlowDiff = ISNULL(SUM
			(
				CASE WHEN F.Status = 2 AND F.RN != 1 THEN F.FlowAmountLimit 				
				WHEN F.Status = 999 THEN 0
				ELSE F.FlowLimit END

			), @intLastconvertFlowDiff) 
	FROM (
		SELECT ROW_NUMBER() OVER (ORDER BY ID DESC) as RN,
				ISNULL(FlowAmountLimit, 0) as FlowAmountLimit, 
				ISNULL(FlowLimit, 0) as FlowLimit,
				Status
		FROM [Event].[FlowAmountLimitLog] 
		WHERE UserID = @intUserID
		  AND CreateTime BETWEEN @dateLastConvertTime AND @dateNOW
	) AS F
END
GO