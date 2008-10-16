quest={}
quest["end"]={}
quest.stop=true
quest.resume=nil
quest["main"]={}
loadmod("caxie.mod")
quest.main["caxie"]=function()
	do_caxie(caxie.main)
	quest.resume=quest.main["caxie"]
end
quest["end"]["caxie"]=function()
	caxie["end"]()
end
do_quest=function(name)
	initmud()
	if quest.main[name]~=nil then
		quest.stop=false
		getinfo()
		quest["main"][name]()
	end
end

initmud=function()
	run(mudsettings)
end

resume=function()
	if quest.stop==false then
		walk["stop"]()
		_roomid=-1
		inittri()
		call(quest["resume"])
	end
end