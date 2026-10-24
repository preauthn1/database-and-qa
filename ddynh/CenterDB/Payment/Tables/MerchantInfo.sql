CREATE TABLE [Payment].[MerchantInfo] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [GWID]           BIGINT         NOT NULL,
    [InfoData]       NVARCHAR (MAX) NOT NULL,
    [Uuid]           NVARCHAR (200) NULL,
    [MerchantStatus] TINYINT        NULL,
    [Status]         TINYINT        NOT NULL,
    [CreateTime]     DATETIME       NULL,
    [LastUpdateTime] DATETIME       NULL,
    [PlatformID]     BIGINT         NULL,
    CONSTRAINT [PK_Payment_MerchantInfo] PRIMARY KEY CLUSTERED ([ID] ASC)
);



