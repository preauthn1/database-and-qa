CREATE TABLE [Money].[Cash] (
    [UserID]       INT          NOT NULL,
    [Amount]       BIGINT       NOT NULL,
    [Code]         VARCHAR (32) CONSTRAINT [DF_Cash_Code] DEFAULT ('') NOT NULL,
    [CouponAmount] BIGINT       DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Cash] PRIMARY KEY CLUSTERED ([UserID] ASC) ON [S_UserID] ([UserID])
) ON [S_UserID] ([UserID]);

