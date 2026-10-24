
Create Function [dbo].[VarCharToHex](@Str Varchar(400))  
returns varchar(800)  
as  
begin  
declare @i int,@Asi int,@ModS int,@res varchar(800),@Len int,@Cres varchar(4),@tempstr varbinary(400)  
select @i = 1,@res='',@len=datalength(@str),@tempStr = Convert(varbinary,@str)  
while @i<=@len   
begin  
Select @Asi = substring(@tempstr,1,1),@Cres=''  
while @Asi <> 0  
begin  
select @Mods = @Asi %16,  
@Cres=Case when (@Mods > 9) then Char(Ascii('A')+@Mods-10)+@Cres else Cast(@Mods as varchar(4)) + @Cres end,  
@Asi = @Asi/16  
end   
Select @res = @res + @Cres,@tempStr = substring(@tempStr,2,@len-1),@i = @i+1   
end  
return @res  
end  
