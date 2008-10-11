_stop=false
run=function(str)
	if ((str=="")or(str==nil)) then return end
	_cmds={}
	local i=0
	re=rex.new("([^;¡£¡¢]+)")
	n=re:gmatch(str,function (m, t)
		i=i+1
		_cmds[i]=m
	end)
	if (_cmds==nil) then return end
	for i, cmd in pairs (_cmds) do
		Queue(cmd,true)
	end 
end
