CREATE TABLE [Event].[BonusCode] (
    [ID]         BIGINT       IDENTITY (1, 1) NOT NULL,
    [UserID]     INT          NULL,
    [Code]       VARCHAR (50) NOT NULL,
    [Status]     TINYINT      CONSTRAINT [DF_BonusCode_Status] DEFAULT ((0)) NOT NULL,
    [InviteCode] VARCHAR (50) NULL,
    [CreateTime] DATETIME     NOT NULL,
    [GetTime]    DATETIME     NULL
);

