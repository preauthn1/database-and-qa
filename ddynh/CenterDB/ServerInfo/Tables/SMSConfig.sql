CREATE TABLE [ServerInfo].[SMSConfig] (
    [id]     TINYINT       NOT NULL,
    [vender] VARCHAR (20)  NOT NULL,
    [name]   NVARCHAR (50) NULL,
    [status] TINYINT       NOT NULL,
    [url]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_SMSConfig] PRIMARY KEY CLUSTERED ([id] ASC)
);



