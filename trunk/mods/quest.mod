quest={}
quest["end"]={}
quest.stop=true
quest.resume=nil
quest["main"]={}
quest.name=""
loadmod("caxie.mod")
quest.main["caxie"]=function()
	do_caxie(caxie.main)
	quest.resume=quest.main["caxie"]
end
quest["end"]["caxie"]=function()
	caxie["end"]()
end
loadmod("beiqi.mod")
quest.main["beiqi"]=function()
	beiqi["main"]()
	quest.resume=quest.main["beiqi"]
end
quest["end"]["beiqi"]=function()
	beiqi["end"]()
end

do_quest=function(name)
	quest.name=name
	initmud()
	if quest.main[name]~=nil then
		quest.stop=false
		getinfo(quest_begin)
	end
end
quest_begin=function()
	setupskill()
	quest["main"][quest.name]()
end
initmud=function()
	run(mudsettings)
end

resume=function()
	if quest.stop==false then
		walk["stop"]()
		unhook()
		_roomid=-1
		inittri()
		call(quest["resume"])
	end
end