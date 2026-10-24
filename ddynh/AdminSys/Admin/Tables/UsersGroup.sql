CREATE TABLE [Admin].[UsersGroup] (
    [Id]        INT IDENTITY (1, 1) NOT NULL,
    [UserID]    INT NOT NULL,
    [SubUserID] INT NOT NULL,
    CONSTRAINT [PK_UsersGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_UsersGroup]
    ON [Admin].[UsersGroup]([UserID] ASC, [SubUserID] ASC);

