CREATE TABLE [Warning].[UserFocus] (
    [Id]     INT IDENTITY (1, 1) NOT NULL,
    [TypeID] INT NOT NULL,
    [UserID] INT NOT NULL,
    CONSTRAINT [PK_UserFocus] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IUX_UserFocus_TypeID_UserID]
    ON [Warning].[UserFocus]([UserID] ASC, [TypeID] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户关注报警', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserFocus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'后台用户编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserFocus', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'报警类型编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserFocus', @level2type = N'COLUMN', @level2name = N'TypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Warning', @level1type = N'TABLE', @level1name = N'UserFocus', @level2type = N'COLUMN', @level2name = N'Id';

