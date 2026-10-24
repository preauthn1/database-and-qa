

CREATE PROCEDURE [dbo].[PrWeb_GetEachOrganizationCountSummary]

AS   


	SELECT o.OrgID , IsNULL(j.TotalUserCount , 0) as TotalUserCount, IsNULL(plm.TotalPlatformCount , 0) as TotalPlatformCount 
	FROM [Admin].[Organization] as o
	left join 
	(
		select OrgID , count(*) as TotalUserCount  from [Admin].[Users]
		group by OrgID 

	) as j on o.OrgID = j.OrgID
	LEFT JOIN 
	(

		SELECT OrgID , count(*) as TotalPlatformCount 
		FROM [Admin].[OrganizationPlatformMapping]
		GROUP BY OrgID

	) as plm ON plm.OrgID = o.OrgID