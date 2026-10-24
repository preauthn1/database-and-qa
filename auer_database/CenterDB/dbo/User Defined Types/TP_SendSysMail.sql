CREATE TYPE [dbo].[TP_SendSysMail] AS TABLE (
    [UserID]       INT      NULL,
    [TypeID]       TINYINT  NULL,
    [Param]        BIGINT   NULL,
    [Status]       TINYINT  NULL,
    [CreateTime]   DATETIME NULL,
    [LastPostTime] DATETIME NULL);

