assert  (package.loadlib (luapath.."mapper.dll","luaopen_mapper")) ()

loadconfig=function()
	include("npcs.ini")
	include("items.ini")
	include("config.ini")
	include("paths.ini")
	include("family.ini")
	walk["open"]=mushmapper.openmap(luapath.."rooms_all.h")
	if (walk[open]==0) then 
		print "文件未找到，请检查设置"
	end
end
loadconfig()