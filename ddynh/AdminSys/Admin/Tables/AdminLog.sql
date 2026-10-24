CREATE TABLE [Admin].[AdminLog] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [UserID]      INT            NOT NULL,
    [Memo]        VARCHAR (512)  NOT NULL,
    [Url]         VARCHAR (1024) NOT NULL,
    [Data]        VARCHAR (MAX)  NULL,
    [IPAddress]   VARCHAR (15)   NOT NULL,
    [WriteTime]   DATETIME       NOT NULL,
    [Method]      NVARCHAR (50)  NULL,
    [RelativeUrl] NVARCHAR (500) NULL,
    [Memo2]       NVARCHAR (200) NULL,
    CONSTRAINT [PK_AdminLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_AdminLog_UserID]
    ON [Admin].[AdminLog]([UserID] ASC);


GO


-- =============================================
-- Author:  Jason
-- Create date: 2018/06/13
-- Description:	依據客服活動紀錄更新最後登入時間
-- =============================================
CREATE TRIGGER [Admin].[TGR_AdminLog]
ON [Admin].[AdminLog] AFTER INSERT
AS
BEGIN
	DECLARE @NowTime	DATETIME = GETDATE()

	DECLARE @UserID		INT

	SELECT @UserID = INSERTED.UserID FROM INSERTED

    UPDATE [Admin].[Users]
	SET [LastLogonTime] = @NowTime
	WHERE
		[UserID] = @UserID
END





GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台访问记录', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'添加时间', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'WriteTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'访问地址', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'Url';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'提交的数据', @level0type = N'SCHEMA', @level0name = N'Admin', @level1type = N'TABLE', @level1name = N'AdminLog', @level2type = N'COLUMN', @level2name = N'Data';

