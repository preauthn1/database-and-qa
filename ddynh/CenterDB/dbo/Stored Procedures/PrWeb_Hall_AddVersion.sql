USE [CenterDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Mars
-- Create date: 2019/10/21
-- Description:	新增大廳版本
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Hall_AddVersion]
(
	@intPlatformID INT,
	@intSkin INT,
	@chvAnVersion VARCHAR(50),
	@chvAnVersion2 VARCHAR(50),
	@chvIOSVersion VARCHAR(50),
	@chvIOSVersion2 VARCHAR(50)
)
AS
BEGIN
	
	SET NOCOUNT ON
	
	IF EXISTS(SELECT * FROM [CenterDB].[ServerInfo].[HallVersions] WHERE PlatformID = @intPlatformID AND HallSkinID = @intSkin AND [Type] = 1)
	BEGIN
		UPDATE [CenterDB].[ServerInfo].[HallVersions] 
		SET [AndroidVersion] = @chvAnVersion, [IOSVersion] = @chvIOSVersion 
		WHERE PlatformID = @intPlatformID AND HallSkinID = @intSkin AND [Type] = 1
	END
	ELSE
	BEGIN
		INSERT INTO [CenterDB].[ServerInfo].[HallVersions](PlatformID, HallSkinID, AndroidVersion, IOSVersion, [Type]) 
        VALUES(@intPlatformID, @intSkin, @chvAnVersion, @chvIOSVersion, 1)
	END

	--
	IF EXISTS(SELECT * FROM [CenterDB].[ServerInfo].[HallVersions] WHERE PlatformID = @intPlatformID AND HallSkinID = @intSkin AND [Type] = 2)
	BEGIN
		UPDATE [CenterDB].[ServerInfo].[HallVersions] 
		SET [AndroidVersion] = @chvAnVersion2, [IOSVersion] = @chvIOSVersion2 
		WHERE PlatformID = @intPlatformID AND HallSkinID = @intSkin AND [Type] = 2
	END
	ELSE
	BEGIN
		INSERT INTO [CenterDB].[ServerInfo].[HallVersions](PlatformID, HallSkinID, AndroidVersion, IOSVersion, [Type]) 
        VALUES(@intPlatformID, @intSkin, @chvAnVersion2, @chvIOSVersion2, 2)
	END
	 
END
GO
