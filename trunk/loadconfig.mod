assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()

loadconfig=function()
	include("npcs.ini")
	include("items.ini")
	include("config.ini")
	include("paths.ini")
	include("family.ini")
	walk["open"]=mushmapper.openmap(GetInfo(67).."rooms_all.h")
	if (walk[open]==0) then 
		print "�ļ�δ�ҵ�����������"
	end
end
loadconfig()