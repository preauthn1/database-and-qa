CREATE TABLE [Event].[FlowAmountLimitLog] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [UserID]          BIGINT         NOT NULL,
    [Type]            TINYINT        CONSTRAINT [DF_FlowAmountLimitLog_Type] DEFAULT ((0)) NOT NULL,
    [SourceTypeID]    INT            NOT NULL,
    [EventID]         INT            NULL,
    [Amount]          BIGINT         CONSTRAINT [DF_FlowAmountLimitLog_Amount] DEFAULT ((0)) NULL,
    [SumFlowAmount]   BIGINT         CONSTRAINT [DF_FlowAmountLimitLog_SumFlowAmount] DEFAULT ((0)) NULL,
    [FlowAmountLimit] BIGINT         CONSTRAINT [DF_FlowAmountLimitLog_FlowAmountLimit] DEFAULT ((0)) NULL,
    [FlowLimit]       BIGINT         CONSTRAINT [DF_FlowAmountLimitLog_FlowLimit] DEFAULT ((0)) NULL,
    [CreateTime]      DATETIME       CONSTRAINT [DF_FlowAmountLimitLog_CreateTime] DEFAULT (getdate()) NULL,
    [LastUpdateTime]  DATETIME       NULL,
    [Status]          INT            CONSTRAINT [DF_FlowAmountLimitLog_Status] DEFAULT ((0)) NULL,
    [StartTime]       DATETIME       NULL,
    [EndTime]         DATETIME       NULL,
    [Memo]            NVARCHAR (256) NULL,
    [UpdateBy]        NVARCHAR (256) NULL,
    [UpdateTime]      DATETIME       CONSTRAINT [DF__FlowAmoun__Updat__043B7C66] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_FlowAmountLimitLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0:Inactive 1:Enable 2:Disabled', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FlowAmountLimitLog', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'流水限制(分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FlowAmountLimitLog', @level2type = N'COLUMN', @level2name = N'FlowAmountLimit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'修改金額', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FlowAmountLimitLog', @level2type = N'COLUMN', @level2name = N'Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'活動ID,無活動時不給', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FlowAmountLimitLog', @level2type = N'COLUMN', @level2name = N'EventID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1:一般充值, 2:代理充值, 3:其他', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'FlowAmountLimitLog', @level2type = N'COLUMN', @level2name = N'Type';

