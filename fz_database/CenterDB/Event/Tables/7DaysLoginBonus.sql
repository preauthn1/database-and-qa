CREATE TABLE [Event].[7DaysLoginBonus] (
    [PlatformID] INT     NOT NULL,
    [AreaID]     INT     NOT NULL,
    [Day1]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day1] DEFAULT ((0)) NOT NULL,
    [Day2]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day2] DEFAULT ((0)) NOT NULL,
    [Day3]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day3] DEFAULT ((0)) NOT NULL,
    [Day4]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day4] DEFAULT ((0)) NOT NULL,
    [Day5]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day5] DEFAULT ((0)) NOT NULL,
    [Day6]       INT     CONSTRAINT [DF_Event.˙7DaysLoginBonus_Day6] DEFAULT ((0)) NOT NULL,
    [Day7]       INT     NOT NULL,
    [Status]     TINYINT CONSTRAINT [DF_Event.˙7DaysLoginBonus_Status] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_7DaysLoginBonus] PRIMARY KEY CLUSTERED ([PlatformID] ASC, [AreaID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0代表平台預設', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'7DaysLoginBonus', @level2type = N'COLUMN', @level2name = N'PlatformID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0代表渠道預設', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'7DaysLoginBonus', @level2type = N'COLUMN', @level2name = N'AreaID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'贈送金幣數(單位:分)', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'7DaysLoginBonus', @level2type = N'COLUMN', @level2name = N'Day1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0: 關, 1: 開', @level0type = N'SCHEMA', @level0name = N'Event', @level1type = N'TABLE', @level1name = N'7DaysLoginBonus', @level2type = N'COLUMN', @level2name = N'Status';

