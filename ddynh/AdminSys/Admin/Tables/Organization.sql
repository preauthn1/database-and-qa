CREATE TABLE [Admin].[Organization] (
    [OrgID]      INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (50)  NOT NULL,
    [ShortName]  NVARCHAR (100) NULL,
    [Memo]       NVARCHAR (50)  NULL,
    [CreateTime] DATETIME       NOT NULL,
    CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED ([OrgID] ASC)
);

