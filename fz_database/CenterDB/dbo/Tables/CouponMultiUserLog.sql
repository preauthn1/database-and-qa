CREATE TABLE [dbo].[CouponMultiUserLog] (
    [LogID]      BIGINT    IDENTITY (1, 1) NOT NULL,
    [CouponCode] CHAR (12) NOT NULL,
    [UserID]     INT       NOT NULL,
    [CreateTime] DATETIME  NOT NULL,
    CONSTRAINT [PK_CouponMultiUserLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_CouponMultiUserLog_CouponCode_UserID]
    ON [dbo].[CouponMultiUserLog]([CouponCode] ASC, [UserID] ASC);

