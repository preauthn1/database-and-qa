CREATE TABLE [Notify].[Notify] (
    [Idx]        INT           IDENTITY (1, 1) NOT NULL,
    [UserID]     INT           NOT NULL,
    [Type]       INT           NOT NULL,
    [Message]    VARCHAR (500) NULL,
    [CreateTime] DATETIME      CONSTRAINT [DF_Notify_CreateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Notify] PRIMARY KEY CLUSTERED ([Idx] ASC, [CreateTime] ASC) ON [S_Day] ([CreateTime])
) ON [S_Day] ([CreateTime]);






GO


