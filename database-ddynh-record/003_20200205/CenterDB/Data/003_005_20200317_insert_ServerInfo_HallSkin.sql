USE CenterDB
GO

DECLARE @chvName NVARCHAR(10) = 'kqp_k',
		@chvCode NVARCHAR(10) = 'UI_kqp_k',
		@now DATETIME = GETDATE(),
		@intHallSkinID INT = 0

IF NOT EXISTS (SELECT * FROM ServerInfo.HallSkin WHERE Code = @chvCode)
BEGIN
	SELECT TOP 1 @intHallSkinID = (HallSkinID + 1) FROM ServerInfo.HallSkin ORDER BY HallSkinID DESC

	INSERT INTO ServerInfo.HallSkin(HallSkinID, Name, Code, Status, CreateTime, LastUpdateTime) 
	VALUES(@intHallSkinID, @chvName, @chvCode, 1, @now, @now)
END