-- =============================================
-- Author:  <xxx>
-- Create date: <xxx>
-- Description:	<删除消息>
-- =============================================
CREATE PROCEDURE [dbo].[PrWeb_Message_MessageAllByMsgID]
	@intMsgID INT					--消息ID
AS
BEGIN
	DELETE FROM [CenterDB].[Message].[MessageList]
    WHERE MsgID=@intMsgID	
    AND CreateTime > dbo.Fn_EmailStartTime()
    DELETE FROM [CenterDB].[Message].[ReceiveUser]
    WHERE MsgID=@intMsgID
    DELETE FROM [CenterDB].[Message].[SendUser]
	WHERE MsgID=@intMsgID
	
	Return 1;
END
