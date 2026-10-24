-- =============================================
-- Author:  Mars
-- Create date: 2019/10/08
-- Description: 公司總計	
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Stat_GetCompanyReport]
(
	@intAdminID		INT = NULL,
	@intAreaID		INT = NULL,
	@intPlatformID	INT = NULL,
	@dtStatTime		DATETIME = NULL,
	@dtEndTime		DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	IF (@dtEndTime IS NULL)
		SET @dtEndTime = getDate();
	
	--篩選平台/渠道
	SELECT * INTO #AdminAccessRight 
	FROM dbo.Fn_GetAdminAccessRights(@intAdminID)
	WHERE (@intPlatformID IS NULL OR PlatformID = @intPlatformID) 
		AND (@intAreaID IS NULL OR AreaID = @intAreaID) 

	SELECT ROW_NUMBER() OVER (ORDER BY A.CreateTime DESC, A.PlatformID ASC, A.AreaID ASC) AS rowNum,
			A.PlatformID,
			B.Name as PlatformName,
			A.AreaID,
			C.AreaName,
			A.CreateTime as [Date],
			(A.WinLoss * -1) as WinLoss,
			A.Tax,
			A.Bonus,
			A.ManualChangeAmount,
			A.AgentWithdrawal,
			A.QZNNBonus,
			A.BlockReduceAmount,
			A.WithdrawalFee,
			((A.WinLoss * -1) - (A.Bonus + A.ManualChangeAmount + A.AgentWithdrawal + A.QZNNBonus) + A.BlockReduceAmount + A.WithdrawalFee) AS CompanyNetAmount
	FROM (
		SELECT PlatformID, 
				AreaID, 
				CreateTime, 
				SUM(WinLoss) AS WinLoss,
				SUM(Tax) AS Tax,
				SUM(Bonus) AS Bonus,
				SUM(ManualChangeAmount) AS ManualChangeAmount,
				SUM(AgentWithdrawal) AS AgentWithdrawal,
				SUM(QZNNBonus) AS QZNNBonus,
				SUM(BlockReduceAmount) AS BlockReduceAmount,
				SUM(WithdrawalFee) AS WithdrawalFee
		FROM (
			SELECT MM.PlatformID, 
					MM.AreaID, 
					convert(varchar(10), MM.CreateTime, 126) as CreateTime, 
					--公司輸贏：(玩家输赢+稅收) -1 (SourceTypeID < 10000, UpdateAmount, TaxAmount)
					WinLoss = CASE WHEN SourceTypeID < 10000 THEN UpdateAmount ELSE 0 END,				
					--稅收：玩家贏的金額 5% (taxAmount)
					Tax = CASE WHEN SourceTypeID < 10000 THEN TaxAmount ELSE 0 END,		
					--優惠：註冊金(10001)、綁定金(10002)、登入七日(21001)、首充10%(11099)、代理充值2%(11099)、(修改金幣)人工優惠活動(21003)
					Bonus = CASE WHEN SourceTypeID IN (10001,10002,21001,11099,21003) THEN UpdateAmount ELSE 0 END,	
					--人工加扣款(13000, 13001)
					ManualChangeAmount = CASE WHEN SourceTypeID IN (13000,13001) THEN UpdateAmount ELSE 0 END,
					AgentWithdrawal = CASE WHEN SourceTypeID = 14003 THEN UpdateAmount ELSE 0 END,
					QZNNBonus = CASE WHEN SourceTypeID = 15001 THEN UpdateAmount ELSE 0 END,
					--封鎖扣除金幣(13002,13003(解封)
					BlockReduceAmount = CASE WHEN SourceTypeID IN (13002,13003) THEN UpdateAmount ELSE 0 END,
					--出款手續費(14000)
					WithdrawalFee = 0
			FROM LogDB.Money.MoneyLog AS MM
			INNER JOIN CenterDB.Users.Userinfo AS UU ON MM.UserID = UU.UserID AND UU.UserType <> 2
			WHERE MM.PlatformID IN (SELECT DISTINCT PlatformID FROM #AdminAccessRight)
			AND MM.AreaID IN (SELECT AreaID FROM #AdminAccessRight)
			AND MM.CreateTime BETWEEN @dtStatTime and @dtEndTime
		UNION ALL
			SELECT BB.PlatformID, 
					BB.AreaID, 
					convert(varchar(10), BB.CreateTime, 126) as CreateTime, 
					WinLoss = 0,				
					Tax = 0,		
					Bonus = 0,	
					ManualChangeAmount = 0,
					--全民代理提現(14003)
					AgentWithdrawal = CASE WHEN SourceTypeID = 14003 THEN UpdateAmount ELSE 0 END,
					--搶庄牛牛彩金(15001)
					QZNNBonus = CASE WHEN SourceTypeID = 15001 THEN UpdateAmount ELSE 0 END,
					BlockReduceAmount = 0,
					WithdrawalFee = 0
			FROM LogDB.Money.BankLog AS BB
			INNER JOIN CenterDB.Users.Userinfo AS UU ON BB.UserID = UU.UserID AND UU.UserType <> 2
			WHERE BB.PlatformID IN (SELECT DISTINCT PlatformID FROM #AdminAccessRight)
			AND BB.AreaID IN (SELECT AreaID FROM #AdminAccessRight)
			AND BB.CreateTime BETWEEN @dtStatTime and @dtEndTime
		UNION ALL
		SELECT MC.PlatformID, 
				MC.AreaID, 
				convert(varchar(10), MC.CreateTime, 126) as CreateTime, 
				WinLoss = 0,
				Tax = 0,
				Bonus = 0,
				ManualChangeAmount = 0,
				AgentWithdrawal = 0,
				QZNNBonus = 0,
				BlockReduceAmount = 0,
				WithdrawalFee = TaxAmount
		FROM LogDB.Money.ConvertLog AS MC
		INNER JOIN CenterDB.Users.Userinfo AS UU ON MC.UserID = UU.UserID AND UU.UserType <> 2
		WHERE MC.Status = 3 
			AND MC.PlatformID IN (SELECT DISTINCT PlatformID FROM #AdminAccessRight)
			AND MC.AreaID IN (SELECT AreaID FROM #AdminAccessRight)
			AND MC.CreateTime BETWEEN @dtStatTime and @dtEndTime
		) AS T
		GROUP BY PlatformID, AreaID, CreateTime
	
	) AS A
	INNER JOIN CenterDB.Area.Platform AS B ON A.PlatformID = B.PlatformID
	INNER JOIN CenterDB.Area.Area AS C ON A.AreaID = C.AreaID

END