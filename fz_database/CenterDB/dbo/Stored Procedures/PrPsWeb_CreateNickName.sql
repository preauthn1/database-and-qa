-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<生成昵称>
-- =============================================
CREATE PROCEDURE [dbo].[PrPsWeb_CreateNickName]
@intNRCount INT,
@chvNickName VARCHAR(32) OUTPUT
AS
SET NOCOUNT ON
DECLARE @intCount INT
SET @intCount = 0
--生成昵称
SET @chvNickName = REPLACE(NEWID(), '-','')

RETURN 1
