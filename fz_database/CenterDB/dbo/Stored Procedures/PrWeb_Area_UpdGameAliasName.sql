
-- =============================================
-- Author:  <xxxx>
-- Create date: <xxxx>
-- Description:	<更新游戏别名清单>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Area_UpdGameAliasName]
@intGameID INT,
@intIconID INT,
@chvIconName varchar(50),
@chvIconTitle varchar(50),
@chvSkin varchar(50),
@chvAliasName varchar(50)
AS
BEGIN

	Update Area.GameAliasName Set IconName=@chvIconName, IconTitle=@chvIconTitle, Skin=@chvSkin, AliasName=@chvAliasName
	Where GameID=@intGameID AND IconID=@intIconID

	return 1

END


