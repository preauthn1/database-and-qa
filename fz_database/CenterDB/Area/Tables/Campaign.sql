CREATE TABLE [Area].[Campaign] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [PlatformID] INT            NOT NULL,
    [AreaID]     INT            NULL,
    [SeqID]      INT            CONSTRAINT [DF_Campaign_SeqID] DEFAULT ((0)) NOT NULL,
    [Picture]    VARCHAR (512)  NOT NULL,
    [Title]      NVARCHAR (100) CONSTRAINT [DF_Campaign_Title] DEFAULT ('') NOT NULL,
    [Tag]        TINYINT        CONSTRAINT [DF_Campaign_Tag] DEFAULT ((0)) NOT NULL,
    [Behavior]   TINYINT        CONSTRAINT [DF_Campaign_Behavior] DEFAULT ((0)) NOT NULL,
    [Link]       VARCHAR (512)  CONSTRAINT [DF_Campaign_Link] DEFAULT ('') NOT NULL,
    [StartTime]  DATETIME       CONSTRAINT [DF_Campaign_StartTime] DEFAULT (getdate()) NOT NULL,
    [EndTime]    DATETIME       NOT NULL,
    [Status]     TINYINT        CONSTRAINT [DF_Campaign_Status] DEFAULT ((1)) NOT NULL,
    [CreateTime] DATETIME       CONSTRAINT [DF_Campaign_CreateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED ([Id] ASC)
);

