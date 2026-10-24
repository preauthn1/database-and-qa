CREATE TABLE [Money].[MoneyLog] (
    [LogID]         INT           IDENTITY (1, 1) NOT NULL,
    [UserID]        INT           NOT NULL,
    [SourceTypeID]  INT           NOT NULL,
    [CurrentAmount] BIGINT        NOT NULL,
    [UpdateAmount]  BIGINT        NOT NULL,
    [TaxAmount]     BIGINT        CONSTRAINT [DF_MoneyLog_TaxAmount] DEFAULT ((0)) NOT NULL,
    [IPAddress]     VARCHAR (15)  NOT NULL,
    [Memo]          VARCHAR (128) NOT NULL,
    [CreateTime]    DATETIME      NOT NULL,
    [AreaID]        INT           NULL,
    [PlatformID]    INT           NULL,
    [TradeID]       BIGINT        DEFAULT ((0)) NOT NULL,
    [FlowAmount]    BIGINT        CONSTRAINT [DF_MoneyLog_FlowAmount] DEFAULT ((0)) NULL
) ON [S_Data] ([CreateTime]);




GO
CREATE CLUSTERED INDEX [IX_MoneyLog_CreateTime]
    ON [Money].[MoneyLog]([CreateTime] ASC)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_MoneyLog_SourceTypeID_UserID_TradeID]
    ON [Money].[MoneyLog]([SourceTypeID] ASC, [UserID] ASC, [TradeID] ASC)
    ON [S_Data] ([CreateTime]);


GO
CREATE NONCLUSTERED INDEX [IX_MoneyLog_STID_PID_INCLUDE]
    ON [Money].[MoneyLog]([SourceTypeID] ASC, [PlatformID] ASC)
    INCLUDE([LogID], [UserID], [AreaID], [IPAddress], [CreateTime])
    ON [S_Data] ([CreateTime]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'金币记录', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'玩家用户编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'更新的数量', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'UpdateAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'税收', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'TaxAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流通类型编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'SourceTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'说明', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'记录编号', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'LogID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'IPAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'当前数量', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'CurrentAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'添加时间', @level0type = N'SCHEMA', @level0name = N'Money', @level1type = N'TABLE', @level1name = N'MoneyLog', @level2type = N'COLUMN', @level2name = N'CreateTime';

