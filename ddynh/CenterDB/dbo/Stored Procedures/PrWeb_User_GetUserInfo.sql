-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<Description,,>
-- Changelog:
--	2018/03/13	alan		修改add @chvUnionpayAccount parameter
--	2018/05/16	Jason		#263 用戶統計-註冊用戶查詢增加查詢條件 新增@intAreaID參數
--	2018/05/18	Jason		#271 用戶統計-註冊用戶查詢增加現金資訊與統計註冊人數,充值人數 增加money.amount
--	2018/05/19	harry		#289 用戶統計-註冊用戶查詢增加 Area.AreaName
--	2018/05/30	Jason		#378 排序調整
--  2018/06/05  Emily       #411 用戶統計頁面 註冊用戶查詢可以用創建時間排序
--	2018/11/10	alan		增加等級搜尋
--	2019/08/08	amy			增加@intAdminID，權限控制
--	2019/08/22	amy			@chvLastlogonIPAddress、@intSex	加入查詢條件
--	2019/11/07	Marshall	新增參數intPlatformID
--	2019/11/26	Marshall	移除近期30日的判斷(沒啥意義)
-- =============================================



CREATE PROCEDURE [dbo].[PrWeb_User_GetUserInfo]
@intAdminID						INT = 1,	--登入者AdminID
@intAreaID						INT = NULL,
@intPlatformID					INT = NULL,
@intUserID						int=null,--用户编号
@chvLoginName					varchar(32)=null,--用户名 
@dtmRegBeginTime				DATETIME=null,--注册开始时间
@dtmRegEndTime					datetime=null,--注册结束时间
@dtmLastlogonBeginTime			datetime=null,--最后登录开始时间
@dtmLastlogonEndTime			datetime=null,--最后登录结束时间
@chvRegIpAddress				varchar(32)=null,--注册IP地址
@intUserType					int=null,--用户类型
@intHdType						int=null,--硬件类型
@chvHdCode						varchar(512)=null,--硬件编号
@chvLastlogonIPAddress			varchar(512)=null,--最后登录IP地址
@intSex							int=null,--性别
@intGrandID						int=null,--等級
@dmlConvertChargeRateBegin		decimal(18,2)=null,--充值兑换比例开始范围
@dmlConvertChargeRateEnd		decimal(18,2)=null,--充值兑换比例结束范围
@lngChargeAmountBegin			bigint=null,		--充值数量开始范围
@lngChargeAmountEnd				bigint=null,		--充值数量开始范围
@lngConvertAmountBegin			bigint=null,		--兑换数量开始范围
@lngConvertAmountEnd			bigint=null,		--兑换数量开始范围
@chvUnionpayAccount				varchar(64)=null,	--銀行卡账号
@chvAlipayAccount				varchar(64)=null,	--支付宝账号
@chvRealName					varchar(64)=null,	--真实姓名
@tnyColumns						TINYINT = 0,		--0:總充值 1:總兌換
@tnySort						TINYINT = 0,		--0:降序 1:升序
@intPageIndex					int=1,
@intPageSize					int=20,
@intPageCount					int output

AS
BEGIN


	SELECT u.* INTO #UserInfoTempTable
	FROM CenterDB.Users.UserInfo as u WITH (NOLOCK)
	LEFT JOIN CenterDB.Area.Area as a on u.AreaID = a.AreaID
	WHERE 
		UserID = (ISNULL(@intUserID, UserID))
		AND u.AreaID = (ISNULL(@intAreaID, u.AreaID))	
		AND a.PlatformID = (ISNULL(@intPlatformID, a.PlatformID))	
		AND u.AreaID IN (SELECT AreaID FROM dbo.Fn_GetAdminAccessRights(@intAdminID))
		AND LoginName = (ISNULL(@chvLoginName, LoginName))
		AND CreateIPAddress = (ISNULL(@chvRegIpAddress, CreateIPAddress))
		AND LastlogonIPAddress = (ISNULL(@chvLastlogonIPAddress, LastlogonIPAddress))
		AND UserType = (ISNULL(@intUserType, UserType))
		AND HDType = (ISNULL(@intHdType, HDType))
		AND HDCode = (ISNULL(@chvHdCode, HDCode))
		AND GradeID = (ISNULL(@intGrandID, GradeID))
		AND Sex = (ISNULL(@intSex, Sex))

		AND u.CreateTime >= (ISNULL(@dtmRegBeginTime, u.CreateTime))
		AND u.CreateTime <= (ISNULL(@dtmRegEndTime, u.CreateTime))

		AND LastLogonTime >= (ISNULL(@dtmLastlogonBeginTime, LastLogonTime))
		AND LastLogonTime <= (ISNULL(@dtmLastlogonEndTime, LastLogonTime))

		AND SumCharge >= (ISNULL(@lngChargeAmountBegin, SumCharge))
		AND SumCharge <= (ISNULL(@lngChargeAmountEnd, SumCharge))

		AND SumConvert >= (ISNULL(@lngConvertAmountBegin, SumConvert))
		AND SumConvert <= (ISNULL(@lngConvertAmountEnd, SumConvert))

		AND (@dmlConvertChargeRateBegin IS NULL OR 1.0*SumConvert/CASE WHEN SumCharge=0 THEN 1 ELSE SumCharge END >= @dmlConvertChargeRateBegin)
		AND (@dmlConvertChargeRateEnd IS NULL OR 1.0*SumConvert/CASE WHEN SumCharge=0 THEN 1 ELSE SumCharge END <= @dmlConvertChargeRateEnd)

		AND (@chvAlipayAccount IS NULL OR AlipayAccount LIKE '%'+@chvAlipayAccount+'%')
		AND (@chvUnionpayAccount IS NULL OR UnionpayAccount LIKE '%'+@chvUnionpayAccount+'%')
		AND (@chvRealName IS NULL OR RealName LIKE '%'+@chvRealName+'%')
		
		
	SELECT @intPageCount=COUNT(UserID)
	FROM #UserInfoTempTable

	;WITH tb AS 
	(
		SELECT a.UserID AS 'Id', a.*, cashamount = isnull(f.amount,0), e.Name AS 'Area.Platform.Name', d.AreaName AS 'Area.AreaName', ISNULL(b.UserID,0) AS BLOCK,
		ROW_NUMBER() OVER (
		ORDER BY 
		CASE	
			WHEN  @tnyColumns = 0 AND @tnySort = 0 THEN a.sumcharge
			WHEN  @tnyColumns = 0 AND @tnySort = 1 THEN (0 - a.sumcharge)
			WHEN  @tnyColumns = 1 AND @tnySort = 0 THEN a.sumconvert
			WHEN  @tnyColumns = 1 AND @tnySort = 1 THEN (0 - a.sumconvert)
			WHEN  @tnyColumns = 2 AND  @tnySort = 0 THEN DATEDIFF(SECOND,'1970-01-01', a.CreateTime)
			WHEN  @tnyColumns = 2 AND  @tnySort = 1 THEN 0 - DATEDIFF(SECOND,'1970-01-01', a.CreateTime)
		END DESC) AS rowid
		FROM #UserInfoTempTable AS a WITH (NOLOCK)
		INNER JOIN Area.Area AS d  WITH (NOLOCK) ON a.AreaID = d.AreaID
		INNER JOIN Area.Platform AS e WITH (NOLOCK) ON d.PlatformID = e.PlatformID
		LEFT JOIN [Money].[Cash] AS f WITH (NOLOCK) ON a.userid = f.userid
		LEFT JOIN [Game].[ForbidUser] AS b WITH (NOLOCK) ON a.UserID=b.UserID
	)	

	SELECT * FROM tb 
	WHERE rowid between @intPageSize * (@intPageIndex-1) +1  and @intPageSize * @intPageIndex

	DROP TABLE #UserInfoTempTable
		
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_User_GetUserInfo] TO [GameUser]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrWeb_User_GetUserInfo] TO [xbuser]
    AS [dbo];

