assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()

loadconfig=function()
	include("npcs.ini")
	include("items.ini")
	include("config.ini")
	include("paths.ini")
	walk["open"]=mushmapper.openmap(GetInfo(67).."rooms_all.h")
	if (walk[open]==0) then 
		print "文件未找到，请检查设置"
	end
end
loadconfig()