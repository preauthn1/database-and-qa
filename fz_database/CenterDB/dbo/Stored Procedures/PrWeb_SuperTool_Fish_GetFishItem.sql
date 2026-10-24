

-- =============================================
-- Author:  alan
-- Create date: 20180908
-- Description:	取得魚款
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_SuperTool_Fish_GetFishItem]
AS
BEGIN

	SET NOCOUNT ON
	Select * from Game.SuperTool_FishItem with (nolock)
	
END
