-- =============================================
-- Author:		<xxx>
-- Create date: <xxx>
-- Description:	<获取游戏公告>

-- 2018/05/29	alan		platform改回傳0,代表全服公告
-- 2018/08/12	Jason		因原本寫法已造成效能問題，調整語法
-- 2018/09/13	alan		新增全平台設定
-- 2018/10/18	Marshall	刪除hardCode、並修正欄位長度超過150會掛掉的問題
-- =============================================
CREATE PROCEDURE [dbo].[PrNs_GetNotice]
AS
SET NOCOUNT ON

	Create Table #t
	(
		Id int,
		PlatformID int,
		MsgContent nvarchar(2000)
	)


	INSERT INTO #t
	SELECT 
		Id,
		CASE WHEN AllPlatform=1 THEN 0 ELSE PlatformID END as PlatformID,
		MsgContent
	FROM CenterDB.Game.GameMessage 
	WHERE status = 1
	AND GETDATE() BETWEEN BeginTime AND EndTime
	AND DATEADD(ss, Interval, ISNULL(LastSendTime,CAST('1990-1-1' AS DATETIME))) <= GETDATE()


	IF @@ROWCOUNT > 0
		BEGIN

			UPDATE gm
			SET gm.LastSendTime = GETDATE()
			FROM #t,CenterDB.Game.GameMessage gm
			WHERE gm.Id = #t.Id

		END

SELECT * FROM #t

DROP TABLE #t

RETURN 1

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrNs_GetNotice] TO [xbuser]
    AS [dbo];

