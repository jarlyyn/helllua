
loadconfigfile=function(str)
	include("configs\\"..str)
end
loadconfig=function()
	loadconfigfile("npcs.ini")
	loadconfigfile("items.ini")
	include("config.ini")
	include("house.ini")
	loadconfigfile("paths.ini")
	loadconfigfile("family.ini")
	loadconfigfile("info.ini")
	walk["open"]=mapper.open(luapath.."rooms_all.h")
	if (walk[open]==0) then
		print "��ͼ�ļ�δ�ҵ�����������"
	else
		for i,v in pairs(houses) do
			house.add(i)
		end
	end
end
loadconfig()
