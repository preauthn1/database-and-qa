CREATE TABLE [Users].[RanID] (
    [UserID] INT NULL,
    [Status] INT CONSTRAINT [DF_RanID_Status] DEFAULT ((0)) NULL
);

