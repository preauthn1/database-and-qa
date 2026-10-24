CREATE TABLE [dbo].[CouponUserData] (
    [CouponCode] CHAR (12) NOT NULL,
    [PlatformID] INT       NOT NULL,
    [Status]     INT       NOT NULL,
    [MultiUser]  INT       NOT NULL,
    [MultiCount] INT       NOT NULL,
    [Amount]     BIGINT    NOT NULL,
    [ExpiryDate] DATETIME  NOT NULL,
    [CreateTime] DATETIME  NOT NULL,
    [UserID]     INT       NULL,
    [UseCount]   INT       NULL,
    [UseDate]    DATETIME  NULL,
    [UpdateTime] DATETIME  NULL,
    CONSTRAINT [PK_CouponUserData] PRIMARY KEY CLUSTERED ([CouponCode] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_CouponUserData_PlatformID_INCLOUD]
    ON [dbo].[CouponUserData]([PlatformID] ASC)
    INCLUDE([CouponCode], [Status]);

