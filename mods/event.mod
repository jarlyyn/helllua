accept={}
accept["ok"]=nil
accept["fail"]=nil
accept.name=""
accept.id=""
accept.gift=""
accept.accepttype=0
do_accept=function(accept_ok,accept_fail)
	accept["ok"]=accept_ok
	accept["fail"]=accept_fail
	EnableTriggerGroup("accept",true)
	accept.gift=""
	setaccepttri()
	accept.cmd()
end

setaccepttri=function(str)
	SetTriggerOption("event_acceptname","match","^(> )*【东拉西扯】"..me.name.."\\["..string.upper(string.sub(me.id,1,1))..string.sub(me.id,2,#me.id).."\\]：(.*)少要猖狂，我来了！$")
end
setaccepttriii=function(str)
	SetTriggerOption("event_acceptwin","match","^(> )*"..str.."身子一退，掉下(.*)！$")
end

accept["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(accept[s])
	end
	EnableTriggerGroup("accept",false)
	accept["ok"]=nil
	accept["fail"]=nil
end

accept.cmd=function()
	accept.accepttype=0
	run("accept")
	infoend(accept.cmdend)
end

accept.resume=function()
	EnableTriggerGroup("accept",true)
	accept.cmd()
end

accept.fighting=function()
	hook(hooks.logok,accept.fightingrecon)
	recon()
end

accept.fightingrecon=function()
	accept.cmd()
end

accept.kill=function()
	if accept.name=="" then
		accept_end_ok()
		return
	end
	accept.getstatus()
end

accept.killcmd=function()
	if room_obj[accept.name]==nil then
		accept_end_ok()
		return
	elseif room_obj[accept.name].id==nil then
		accept_end_ok()
		return
	end
	fightpreper()
	accept.id=room_obj[accept.name].id
	run("fight "..room_obj[accept.name].id)
	do_kill(room_obj[accept.name].id,accept.killend,accept_end_ok)
end

accept.getstatus=function()
	getstatus(accept.check)
end

accept.check=function()
	if 	testneili() then
		dazuo(accept.getstatus)
	elseif checkheal(accept.getstatus,accept.getstatus,true)then
	else
		run("l")
		infoend(accept.killcmd)
	end
end


accept.cmdend=function()
	if accept.accepttype==2 then
		accept.cmd()
	elseif accept.accepttype==3 then
		accept.kill()
	elseif accept.accepttype==1 then
		accept.fighting()
	elseif accept.accepttype==4 then
	else
		accept_end_ok()
	end
end

accept_end_ok=function()
	accept["end"]("ok")
end

accept_end_fail=function()
	accept["end"]("fail")
end

event_acceptrecon=function(n,l,w)
	accept.accepttype=1
end

event_acceptretry=function(n,l,w)
	accept.accepttype=2
end
event_accepting=function(n,l,w)
	accept.accepttype=3
end

event_acceptname=function(n,l,w)
	accept.name=w[2]
	setaccepttriii(w[2])
	_roomid=yzgcloc
	hook(hooks.logok,accept.resume)
	recon()
end
event_acceptwin=function(n,l,w)
	w[2]=getitemnum(w[2])
	print(w[2])
	accept.gift=w[2]
	if accept.gift=="" then
		return
	end
	run("l")
	infoend(accept.getgift)
end

accept.killend=function()
	busytest(accept_end_ok)
end

accept.getgift=function()
	local giftid=room_obj[accept.gift]
	if giftid==nil then
		accept_end_ok()
		return
	end
	if giftid.id==nil then
		accept_end_ok()
		return
	end
	run("get "..giftid.id)
	infoend(accept_end_ok)
end
