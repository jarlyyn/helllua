dropongroundlist={}
dropongroundlist["luosha dan"]=true
dropongroundlist["ÐùÔ¯²¹ÐÄµ¤"]=true

dropgift={}
dropgift["ok"]=nil
dropgift["fail"]=nil
dropgift.baoguofull=false
dropgift.enterchatfail=false
dropgift.gift=""
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
		go(2046,dropgift.arrive,dropgift.testbaoguo)
	else
		busytest(dropgift.testbaoguo)
	end
end
dropgift.arrive=function()
	busytest(dropgift.arrivechat)
end

dropgift.arrivechat=function()
	EnableTriggerGroup("enterchatfail",false)
	if dropongroundlist[dropgift.gift]== true then
		run("drop "..dropgift.gift)
		busytest(dropgift_end_ok)
		return
	end
	if jiuzhuanfull==true and dropgift.gift=="jiuzhuan jindan"  then
		getbagitems("budai of here")
		busytest(dropgift.budaiarrive)
		return
	end
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
dropgift.budaiarrive=function()
	if bagscount["budai of here"]==0 then
		jiuzhuancount=0
	else
		jiuzhuancount=getnum(bags["budai of here"]["jiuzhuan jindan"])
	end
	if jiuzhuancount==20 then
		if itemsnum("baoguo")==0 then
			if room_obj["baoguo"]~=nil then
				run("get baoguo")
			else
				item["go"]("baoguo",1,dropgift.putgift,dropgift_end_fail)
				return
			end
		end
		dropgift.putgift()
		return
	end
	if getnum(bagscount["budai of here"])>1 or (getnum(bagscount["budai of here"])==1 and jiuzhuancount==0) or room_obj["budai"]==nil then
		item["go"]("budai",1,dropgift.budaiok,dropgift_end_fail)
	else
		dropgift.putbudai()
	end
end
dropgift.budaiok=function()
	go(2046,dropgift.dropbudai,dropgift_end_fail)
end
dropgift.dropbudai=function()
	run("drop budai;l")
	dropgift.putbudai()
end
dropgift.putbudai=function()
	run("put "..dropgift.gift.." in budai of here")
	dropgift_end_ok()
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
	walk["end"]("fail")
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
	run("drop baoguo")
	item["go"]("baoguo",itemsnum("baoguo")+1,dropgift.putbaoguo,dropgift_end_fail)
end

dropgift.putbaoguo=function()
	go(2046,dropgift.putbaoguocmd,dropgfit_end_fail)
end

dropgift.putbaoguocmd=function()
	run("get baoguo;put baoguo in baoguo 2")
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
