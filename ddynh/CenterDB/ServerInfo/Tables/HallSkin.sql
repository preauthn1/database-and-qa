CREATE TABLE [ServerInfo].[HallSkin] (
    [HallSkinID]     INT          NOT NULL,
    [Name]           VARCHAR (20) NOT NULL,
    [Code]           VARCHAR (20) NOT NULL,
    [Status]         TINYINT      CONSTRAINT [DF_HallSkin_Status] DEFAULT ((0)) NOT NULL,
    [CreateTime]     DATETIME     CONSTRAINT [DF_HallSkin_CreateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdateTime] DATETIME     CONSTRAINT [DF_HallSkin_LastUpdateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_HallSkin] PRIMARY KEY CLUSTERED ([HallSkinID] ASC)
);

