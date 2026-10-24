USE [CenterDB]
GO
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'PrPs_Unlimit_GetRewardTips')
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	SET @SQL = 'CREATE PROCEDURE [dbo].[PrPs_Unlimit_GetRewardTips] AS BEGIN RETURN END'
	EXEC (@SQL)
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  
-- Create date: 20190430
-- Description: 无极限-奖励说明
-- 	2020/02/06 	Mars 			調整業績計算
-- =============================================
ALTER PROCEDURE [dbo].[PrPs_Unlimit_GetRewardTips]

AS
BEGIN

	SET NOCOUNT ON

	declare @chvSelf varchar(500) = '直销业绩150万<BR>160 X 150<BR>返佣24000'
	declare @chvAgentA varchar(500)  = '推广业绩300万<BR>级差(160-145) X 300<BR>返佣4500'
	declare @chvAgentB varchar(500)  = '推广业绩100万<BR>级差(160-125) X 100<BR>返佣3500'
	declare @chvAgentC varchar(500)  = '推广业绩401万<BR>级差(160-155) X 401<BR>返佣2005'
	declare @chvAgentD varchar(500)  = '推广业绩50万<BR>级差(160-110) X 50<BR>返佣2500'
	declare @chvSummary varchar(500) = '本周返佣总合计：24000+4500+3500+2005+2500=36505元'


	declare @temp_unlimitlevel table (lv int,name varchar(30),minamount bigint,maxamount bigint,BonusRate varchar(30))

	insert into @temp_unlimitlevel
	EXEC [Club02].[dbo].[PrPs_Unlimit_GetRewardTips]

	select 
	@chvSelf as [Self],
	@chvAgentA as AgentA,
	@chvAgentB as AgentB,
	@chvAgentC as AgentC,
	@chvAgentD as AgentD,
	@chvSummary as AgentBonus


	select	lv,
			name,
			minamount,
			maxamount,
			BonusRate
	from @temp_unlimitlevel
		

	return 1
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PrPs_Unlimit_GetRewardTips] TO [GameUser]
    AS [dbo];

