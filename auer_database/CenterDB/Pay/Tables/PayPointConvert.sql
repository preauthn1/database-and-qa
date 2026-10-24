CREATE TABLE [Pay].[PayPointConvert] (
    [Id]          INT    IDENTITY (1, 1) NOT NULL,
    [PayTypeID]   INT    NOT NULL,
    [Amount]      BIGINT NOT NULL,
    [PointAmount] BIGINT NOT NULL,
    [Bonus]       BIGINT CONSTRAINT [DF_PayPointConvert_Bonus] DEFAULT ((0)) NOT NULL
);

