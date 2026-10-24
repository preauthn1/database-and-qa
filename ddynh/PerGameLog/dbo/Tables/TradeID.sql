CREATE TABLE [dbo].[TradeID] (
    [id] INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_TradeID] PRIMARY KEY CLUSTERED ([id] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲桌號/場次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TradeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'遊戲桌號/場次流水編號', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TradeID', @level2type = N'COLUMN', @level2name = N'id';

