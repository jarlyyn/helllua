
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
	walk["open"]=mapper.open(luapath.."rooms_all.h")
	if (walk[open]==0) then 
		print "��ͼ�ļ�δ�ҵ�����������"
	end
end
loadconfig()