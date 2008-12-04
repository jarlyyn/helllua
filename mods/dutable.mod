dutable={}
dutable["ok"]=nil
dutable["fail"]=nil

do_dutable=function(dutable_ok,dutable_fail)
	dutable["ok"]=dutable_ok
	dutable["fail"]=dutable_fail
	busytest(dutable.main)
end

dutable["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(dutable[s])
	end
	dutable["ok"]=nil
	dutable["fail"]=nil
end

dutable_end_ok=function()
	dutable["end"]("ok")
end

dutable_end_fail=function()
	dutable["end"]("fail")
end

dutable.items={}
dutable.items["¸ÉÁ¸"]={min=1000,max=1000}
dutable.items["Å£Æ¤Ë®´ü"]={min=8,max=8}
dutable.items["yingxiong ling"]={min=1,max=1}

dutable.main=function()
	if quest.stop then
		dutable["end"]()
		return
	end
	if _roomid==-1 then go(-2,dutable.main,dutable.main) end
	if _roomid~=1938 then
		getstatus(dutable["check"])
	else
		getstatus(dutable.cmd)
	end
end

dutable.loop=function()
	busytest(dutable.loopcmd)
end
dutable.loopcmd=function()
	do_dutable(dutable.loop,dutable.loop)
end

dutable.check=function()
	if do_check(dutable["main"]) then
	elseif checkitems(dutable.items,dutable["main"],dutable["main"]) then
	else
		go(1938,dutable.main,dutable.main)
	end
end

dutable.cmd=function()
	if itemsnum("Å£Æ¤Ë®´ü")==0 or itemsnum("¸ÉÁ¸")==0 then
		run("quit")
		return
	end
	if testneili() then
			dazuo(dutable.main)
	else
			run("du table;du table;du table;du table")
			busytest(dutable.main)
	end
end
