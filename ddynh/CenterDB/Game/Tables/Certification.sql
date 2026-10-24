CREATE TABLE [Game].[Certification] (
    [UserID]  INT          NOT NULL,
    [CerCode] VARCHAR (32) NOT NULL,
    CONSTRAINT [PK_Certification] PRIMARY KEY CLUSTERED ([UserID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'游戏玩家证书', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Certification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Certification', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'证书字符串', @level0type = N'SCHEMA', @level0name = N'Game', @level1type = N'TABLE', @level1name = N'Certification', @level2type = N'COLUMN', @level2name = N'CerCode';

