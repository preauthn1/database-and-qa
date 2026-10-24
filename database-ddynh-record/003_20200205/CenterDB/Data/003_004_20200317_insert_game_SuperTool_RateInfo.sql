USE CenterDB
GO

DECLARE @TempData TABLE (GameID INT, RateID INT, Value INT)
DECLARE @intGameID INT = 2009

INSERT INTO @TempData (GameID, RateID, Value) VALUES 
(@intGameID, 1, 20), 
(@intGameID, 2, 30), 
(@intGameID, 3, 40), 
(@intGameID, 4, 70), 
(@intGameID, 5, 89), 
(@intGameID, 6, 99), 
(@intGameID, 7, 99), 
(@intGameID, 8, 99), 
(@intGameID, 9, 99)

MERGE Game.SuperTool_RateInfo AS A
USING
(
	SELECT * FROM @TempData
) AS B 
ON (A.GameID = B.GameID AND A.RateID = B.RateID)
WHEN MATCHED THEN
	UPDATE SET A.Value = B.Value
WHEN NOT MATCHED THEN
	INSERT(GameID, RateID, Value)
	VALUES(B.GameID, B.RateID, B.Value);