CREATE TABLE [Money].[Bank] (
    [UserID] INT          NOT NULL,
    [Amount] BIGINT       NOT NULL,
    [Code]   VARCHAR (32) CONSTRAINT [DF_Bank_Code] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED ([UserID] ASC) ON [S_UserID] ([UserID])
) ON [S_UserID] ([UserID]);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户银行记录', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Bank';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Bank', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'财富码', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Bank', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金额', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'Bank', @level2type = N'COLUMN', @level2name = N'Amount';

