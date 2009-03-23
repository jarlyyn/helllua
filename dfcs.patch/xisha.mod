xisha={}
xisha.loc=mapper.newarea(1)
mapper.readroom(xisha.loc,tostring(xisha.loc).."=Ï´É³|n:1455,")
mapper.addpath(1455,"s:"..tostring(xisha.loc)..",")

print("ÔØÈëÏ´É³Ä£¿é£¬Ö¸ÁîÎª#xisha")

xisha["ok"]=nil
xisha["fail"]=nil
do_xisha=function(xisha_ok,xisha_fail)
	xisha["ok"]=xisha_ok
	xisha["fail"]=xisha_fail
	busytest(xisha.main)
end

xisha["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(xisha[s])
	end
	xisha["ok"]=nil
	xisha["fail"]=nil
end

xisha_end_ok=function()
	xisha["end"]("ok")
end

xisha_end_fail=function()
	xisha["end"]("fail")
end

xisha["main"]=function()
	if quest.stop then
		xisha["end"]()
		return
	end
	getstatus(xisha["check"])
end

xisha["check"]=function()
	if do_check(xisha["main"]) then
	elseif checkstudy(xisha["main"]) then
	elseif checkfangqi(xisha["main"],xisha["main"]) then
	else
		go(xisha.loc,xisha.arrive,xisha_end_fail)
	end
end

xisha.arrive=function()
	run("xi sha")
	busytest(xisha.main)
end


quest.main["xisha"]=function()
	do_xisha()
	quest.resume=quest.main["letter"]
end
quest["end"]["xisha"]=function()
	xisha["end"]()
end

alias_xisha=function(m,l,w)
	do_quest("xisha")
end
