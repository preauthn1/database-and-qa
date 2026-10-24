CREATE TABLE [dbo].[CouponCode] (
    [ID]         INT       IDENTITY (1, 1) NOT NULL,
    [CouponCode] CHAR (12) NOT NULL,
    [Status]     INT       NOT NULL,
    CONSTRAINT [PK_CouponCode] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_CouponCode_Code]
    ON [dbo].[CouponCode]([CouponCode] ASC, [Status] ASC);

