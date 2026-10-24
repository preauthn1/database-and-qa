CREATE TABLE [Money].[Cash] (
    [UserID] INT          NOT NULL,
    [Amount] BIGINT       NOT NULL,
    [Code]   VARCHAR (32) CONSTRAINT [DF_Cash_Code] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_Cash] PRIMARY KEY CLUSTERED ([UserID] ASC) ON [S_UserID] ([UserID])
) ON [S_UserID] ([UserID]);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户现金记录', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Cash';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Cash', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'财富码', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Cash', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Cash', @level2type = N'COLUMN', @level2name = N'Amount';

