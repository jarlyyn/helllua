assert  (package.loadlib (luapath.."mapper.dll","luaopen_mapper")) ()
loadconfigfile=function(str)
	include("configs\\"..str)
end
loadconfig=function()
	loadconfigfile("npcs.ini")
	loadconfigfile("items.ini")
	include("config.ini")
	loadconfigfile("paths.ini")
	loadconfigfile("family.ini")
	loadconfigfile("info.ini")
	walk["open"]=mushmapper.openmap(luapath.."rooms_all.h")
	if (walk[open]==0) then 
		print "��ͼ�ļ�δ�ҵ�����������"
	end
end
loadconfig()