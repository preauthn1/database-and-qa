-- =============================================
-- Author:		<Amy>
-- Create date: <2019-10-08>
-- Description:	<用ID抓取payType>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_GetPayTypeByID]
	@intPayTypeID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM CenterDB.Payment.PayType WHERE ID = @intPayTypeID
END