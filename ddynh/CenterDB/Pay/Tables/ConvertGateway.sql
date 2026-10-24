CREATE TABLE [Pay].[ConvertGateway] (
    [ID]          INT            IDENTITY (50, 1) NOT NULL,
    [GatewayName] VARCHAR (50)   NOT NULL,
    [ConvertType] TINYINT        NOT NULL,
    [Status]      TINYINT        NOT NULL,
    [CreateTime]  DATETIME       CONSTRAINT [DF__ConvertGa__Creat__62707447] DEFAULT (getdate()) NOT NULL,
    [UpdareTime]  DATETIME       CONSTRAINT [DF__ConvertGa__Updar__63649880] DEFAULT (getdate()) NOT NULL,
    [UpdateBy]    NVARCHAR (200) NULL,
    CONSTRAINT [PK_ConvertGateway] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'开关', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGateway', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代付类型; 1:支付宝;2:银联', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGateway', @level2type = N'COLUMN', @level2name = N'ConvertType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代付商名称', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGateway', @level2type = N'COLUMN', @level2name = N'GatewayName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'代付商编号', @level0type = N'SCHEMA', @level0name = N'Pay', @level1type = N'TABLE', @level1name = N'ConvertGateway', @level2type = N'COLUMN', @level2name = N'ID';

