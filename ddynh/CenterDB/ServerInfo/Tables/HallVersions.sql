CREATE TABLE [ServerInfo].[HallVersions] (
    [PlatformID]     INT          NOT NULL,
    [HallSkinID]     INT          CONSTRAINT [DF_HallVersions_Skin] DEFAULT ((0)) NOT NULL,
    [AndroidVersion] VARCHAR (20) CONSTRAINT [DF_HallVersions_AndroidVersion] DEFAULT ('1.0.0') NOT NULL,
    [IOSVersion]     VARCHAR (20) CONSTRAINT [DF_HallVersions_IOSVersion] DEFAULT ('1.0.0') NOT NULL,
    [Type]           TINYINT      CONSTRAINT [DF_HallVersions_Type] DEFAULT ((1)) NOT NULL,
    [CreateTime]     DATETIME     CONSTRAINT [DF_HallVersions_CreateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdateTime] DATETIME     CONSTRAINT [DF_HallVersions_LastUpdateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_HallVersions] PRIMARY KEY CLUSTERED ([PlatformID] ASC, [HallSkinID] ASC, [Type] ASC),
    CONSTRAINT [FK_HallVersions_HallVersions] FOREIGN KEY ([PlatformID], [HallSkinID], [Type]) REFERENCES [ServerInfo].[HallVersions] ([PlatformID], [HallSkinID], [Type])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1:真实版本, 2:临时版本', @level0type = N'SCHEMA', @level0name = N'ServerInfo', @level1type = N'TABLE', @level1name = N'HallVersions', @level2type = N'COLUMN', @level2name = N'Type';

