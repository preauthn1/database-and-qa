CREATE TABLE [Payment].[PayTypeDisable] (
    [ID]         BIGINT IDENTITY (1, 1) NOT NULL,
    [PayTypeID]  BIGINT NOT NULL,
    [PlatformID] BIGINT NOT NULL,
    CONSTRAINT [PK_Payment_PayTypeDisable] PRIMARY KEY CLUSTERED ([ID] ASC)
);

