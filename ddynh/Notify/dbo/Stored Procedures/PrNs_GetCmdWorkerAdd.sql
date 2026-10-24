-- =============================================
-- Author:		Rory
-- Create date: 20190828
-- Description:	添加指令工作通知
-- =============================================
CREATE PROCEDURE [dbo].[PrNs_GetCmdWorkerAdd](
	@intCommandType		INT, -- 0 刷全大廳版號及配置, 1 刷全遊戲版號
	@sParam		VARCHAR(512) = NULL
)
AS
BEGIN
SET NOCOUNT ON

INSERT INTO Notify.CmdWorker (CommandType, SParam, Status, CreateTime, LastPostTime) VALUES (
	@intCommandType,
	@sParam,
	0,
	GETDATE(),
	GETDATE()
)

RETURN 1
END