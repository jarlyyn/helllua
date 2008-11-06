dropgift={}
dropgift["ok"]=nil
dropgift["fail"]=nil
dropgift.baoguofull=false
dropgift.enterchatfail=false
chatroom=nil
do_dropgift=function(giftid,dropgift_ok,dropgift_fail)
	dropgift["ok"]=dropgift_ok
	dropgift["fail"]=dropgift_fail
	dropgift.gift=giftid
	dropgift.enterchatfail=false
	if chatroom==nil then
		getmudvar()
		infoend(dropgift.main)
	else
		dropgift.main()
	end
end
dropgift.main=function()
	busytest(dropgift.gochat)
end
dropgift["end"]=function(s)
	EnableTriggerGroup("enterchatfail",failse)
	if ((s~="")and(s~=nil)) then
		call(dropgift[s])
	end
	dropgift["ok"]=nil
	dropgift["fail"]=nil
end

dropgift_end_ok=function()
	dropgift["end"]("ok")
end

dropgift_end_fail=function()
	dropgift["end"]("fail")
end


dropgift.gochat=function()
	if canenterchat()==true then
		EnableTriggerGroup("enterchatfail",true)
		go(2046,dropgift.arrive,dropgift_end_fail)
	else
		busytest(dropgift.testbaoguo)
	end
end
dropgift.arrive=function()
	busytest(dropgift.arrivechat)
end

dropgift.arrivechat=function()
	EnableTriggerGroup("enterchatfail",false)
	if itemsnum("baoguo")==0 then
		if room_obj["baoguo"]~=nil then
			run("get baoguo")
		else
			item["go"]("baoguo",1,dropgift.putgift,dropgift_end_fail)
			return
		end
	end
	dropgift.putgift()
end

dropgift.testbaoguo=function()
	if itemsnum("baoguo")==0 then
			item["go"]("baoguo",1,dropgift.putgift,dropgift_end_fail)
	else
		busytest(dropgift.putgift)
	end
end

dropgift_enterchatfail=function(n,l,w)
	dropgift.enterchatfail=true
	walk["end"]()
	busytest(dropgift.testbaoguo)
end

dropgift.putgift=function()
	dropgift.baoguofull=false
	catch("giftbaoguofail","put "..dropgift.gift.." in baoguo")
	infoend(dropgift.putgiftok)
end

giftbaoguofail=function(n,l,w)
	dropgift.baoguofull=true
end

dropgift.putgiftok=function()
	if dropgift.baoguofull==true then
		busytest(dropgift.buybaoguo)
	else
		busytest(dropgift.testdropbaoguo)
	end
end

dropgift.buybaoguo=function()
	item["go"]("baoguo",2,dropgift.putbaoguo,dropgift_end_fail)
end

dropgift.putbaoguo=function()
	run("put baoguo 2 in baoguo")
	busytest(dropgift.testdropbaoguo)
end

dropgift.testdropbaoguo=function()
	if canenterchat()==true then
		go(2046,dropgift.dropbaoguo,dropgfit_end_fail)
	else
		busytest(dropgift_end_ok)
	end
end
dropgift.dropbaoguo=function()
	run("drop baoguo")
	busytest(dropgift_end_ok)
end
canenterchat=function()
	if chatroom=="" or chatroom==nil or dropgift.enterchatfail==true then
		return false
	else
		return true
	end
end

checkgiftdrop=function(_droplist,drop_ok,drop_fail)
	for i,v in pairs(_droplist) do
		if itemsnum(i)>0 then
			do_dropgift(v,drop_ok,drop_fail)
			return true
		end
	end
end