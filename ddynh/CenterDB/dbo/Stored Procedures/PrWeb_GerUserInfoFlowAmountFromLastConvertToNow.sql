-- =============================================
-- Author:		Amy
-- Create date: 2019-08-01
-- Description:	UserInfo/Search頁面中，稽核流水欄位所需資料
-- 2019-08-20	Amy	稽核流水欄位的流水限額改讀其他資料來源，原先LastconvertFlowAmountLimit仍供一倍流水欄位使用(不刪除)
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GerUserInfoFlowAmountFromLastConvertToNow]
	-- Add the parameters for the stored procedure here
@intUserID INT
AS
BEGIN
	SET NOCOUNT ON;

--內部預設
DECLARE @dateLastConvertTime DATETIME;			--最後一次提款的放款時間
DECLARE @dateNOW DATETIME = GETDATE();			--目前的時間
DECLARE @intLastConvertFlowAmountLimit INT = 0;	--從最後一次提領到現在的流水限額(充值需要一倍流水才可提領，所以流水限額 = 充值金額 * 1)
DECLARE @intLastConvertFlowDiff INT = 0;		--從最後一次提領到現在遊戲輸贏的流水(預設總流水 - 上次提領時的流水)
DECLARE @intSumFlowAmountLimit INT = 0			--從流水稽核LOG表讀取流水限制

EXEC [CenterDB].[dbo].[PrWeb_GetLastConvertFlowAmountAndLastConvertTime] 
@intUserID = @intUserID,
@intLastConvertFlowDiff = @intLastConvertFlowDiff					OUTPUT,	--從最後一次提領到現在遊戲輸贏的流水(預設總流水 - 上次提領時的流水)
@intLastConvertFlowAmountLimit = @intLastConvertFlowAmountLimit		OUTPUT,	--從最後一次提領到現在的一倍流水限額(充值需要一倍流水才可提領，所以流水限額 = 充值金額 * 1)
@intSumFlowAmountLimit = @intSumFlowAmountLimit						OUTPUT,	--從最後一次提領到現在的稽核流水限額
@dateLastConvertTime = @dateLastConvertTime							OUTPUT,	--最後一次提款的放款時間
@dateNOW = @dateNOW													OUTPUT	--目前的時間

SELECT FlowAmountLimit = @intSumFlowAmountLimit,
		FlowAmount = @intLastConvertFlowDiff,
		beginTime = @dateLastConvertTime,
		endTime = @dateNOW

END
