-- =============================================
-- Author:  jason
-- Create date: 2019/04/11
-- Description: USER 查询系统默认比例
-- 2019/09/12 	Mars		增加UserID查詢全民代理分成比例
-- =============================================
CREATE PROCEDURE [dbo].[PrPs_UserAgent_GetAgentTaxList]
(
	@intUserID INT = NULL
)
AS
BEGIN

	set nocount on
	DECLARE @intCount INT = 0

	/*  回传明细  */
	IF (@intUserID IS NOT NULL)
	BEGIN
		SELECT @intCount = COUNT(*)
		FROM [Club02].[dbo].[UserAgentUserRate]
		WHERE UserID = @intUserID
	END

	IF (@intCount > 0) 
	BEGIN
		SELECT [UserLevel] as [Level]
		  ,[Stage1]
		  ,[Stage2]
		  ,[Stage3]
		FROM [Club02].[dbo].[UserAgentUserRate]
		WHERE UserID = @intUserID
	END
	ELSE
	BEGIN
		SELECT [Level]
			  ,[Stage1]
			  ,[Stage2]
			  ,[Stage3]
			--  ,[TaxAmount]
		FROM [Club02].[dbo].[UserAgentSystemLevelRate]
	END

	return 1
END





