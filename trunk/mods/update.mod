version=3
mclversion=tonumber(GetVariable("version"))

if mclversion==nil then 
	mclversion=0
end

addtri=function(triname,trimatch,trigroup,triscript)
	AddTriggerEx(triname, trimatch, "", flag_base, -1, 0, "",  triscript, 0, 100)
	SetTriggerOption(triname,"group",trigroup)
end

flag_base=1064
flag_base_enable=1065

updateversion=function()
	print("����mcl�ļ�")
	addtri("remote","^(> )*[^~].{1,7}\\((.*)\\)�����㣺do (.+)","system","remote_called")
	addtri("cantell",'^can_tell\\s*"(.+)"',"mudvar","mudvar_teller")
	AddAlias("alias_start","start","",flag_base_enable,"alias_start")
end


if mclversion<version then
	updateversion()
	print("�汾�������")
	SetVariable("version",tostring(version))
	inittri()
end
