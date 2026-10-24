

-- =============================================
-- Author:  Mars
-- Create date: 20191204
-- Description:	游戏JLBPK 新增監控名單
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_JLBPK_AddVIPUser]
(
	@intUserID INT,
	@intUserWeight INT = 0,
	@lngTargetMoney BIGINT = 0,
	@lngAccumulatedMoney BIGINT = 0,
	@intStatus TINYINT = 0,
	@chvOperator varchar(50)
)
AS
BEGIN

	SET NOCOUNT ON

	IF NOT EXISTS(SELECT 1 FROM Game.SuperTool_JLBPK_VIPUser WITH(NOLOCK) WHERE UserID = @intUserID)
	BEGIN

	DECLARE @dtNow DATETIME = GETDATE()

		INSERT INTO Game.SuperTool_JLBPK_VIPUser (
		[UserID],
		[UserWeight],
		[TargetMoney],
		[AccumulatedMoney],
		[Status],
		[Operator],
        [CreateTime],
        [LastUpdateTime]
		) values(
		@intUserID,
		@intUserWeight,
		@lngTargetMoney,
		@lngAccumulatedMoney,
		@intStatus,
		@chvOperator, 
		@dtNow, 
		@dtNow)

	END

	RETURN 1
END