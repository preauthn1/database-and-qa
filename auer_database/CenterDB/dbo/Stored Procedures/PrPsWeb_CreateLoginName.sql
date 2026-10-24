-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<生成用户名>
-- =============================================
CREATE PROCEDURE [dbo].[PrPsWeb_CreateLoginName]
@chvPrefix VARCHAR(32) = NULL,
@intLen INT,
@chvLoginName VARCHAR(32) OUTPUT
AS
SET NOCOUNT ON

SET @chvLoginName = LEFT(ISNULL(@chvPrefix,'') + REPLACE(NEWID(), '-', ''), @intLen)

RETURN 1
