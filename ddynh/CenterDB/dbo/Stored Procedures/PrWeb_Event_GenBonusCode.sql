
-- =============================================
-- Author:  jason
-- Create date: 2019/07/21
-- Description:	預產活動序號 (僅工程人員使用)
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Event_GenBonusCode]
(
	@intCodeCounts	INT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @lenth INT = 12
	DECLARE @chvCode VARCHAR(12)
	DECLARE @Status INT = 0
	DECLARE @MinNo INT = 1
	DECLARE @MaxNo INT = @intCodeCounts


	WHILE(@MinNo <= @MaxNo)
	BEGIN
		SET @chvCode = ''
		SELECT @chvCode = COALESCE(@chvCode, '') + n
		FROM (	SELECT TOP (@lenth) CHAR(number) n FROM master..spt_values
				WHERE TYPE = 'P' AND 
					(number BETWEEN ASCII(0) AND ASCII(9)
					OR number BETWEEN ASCII('A') AND ASCII('Z')
					OR number BETWEEN ASCII('a') AND ASCII('z'))
					ORDER BY NEWID()
			) AS a

		IF NOT EXISTS (SELECT TOP 1 1 FROM [Event].[BonusCode] WITH (NOLOCK) WHERE [Code] COLLATE Chinese_PRC_CI_AS = @chvCode)
		BEGIN
			SET @MinNo = @MinNo + 1

			INSERT INTO [Event].[BonusCode] ([Code],[CreateTime]) VALUES (@chvCode,GETDATE())
		END
	END

END