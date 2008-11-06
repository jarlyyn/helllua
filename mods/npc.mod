npc={name="",id="",loc=-1,nobody=0}

npchere=function(npcid,str)
	npc.nobody=0
	run("shou "..npcid)
	catch("nobody",str..";")
end
npc_nobody=function(n,l,w)
	npc.nobody=1
end
npc_nobody2=function(n,l,w)
	npc.nobody=2
end


searchnpc={}
searchnpc["ok"]=nil
searchnpc["fail"]=nil

do_searchnpc=function(searchnpc_ok,searchnpc_fail)
	npc.loc=-1
	searchnpc["ok"]=searchnpc_ok
	searchnpc["fail"]=searchnpc_fail
	EnableTriggerGroup("npc",true)
	do_search(searchnpc.step,searchnpc_end_fail,searchnpc_end_ok,searchnpc_end_fail)
end

searchnpc["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(searchnpc[s])
	end
	EnableTriggerGroup("npc",false)
	searchnpc["ok"]=nil
	searchnpc["fail"]=nil
end

searchnpc_end_ok=function()
	searchnpc["end"]("ok")
end

searchnpc_end_fail=function()
	searchnpc["end"]("fail")
end

searchnpc.step=function()
	busytest(searchnpc.test)
end

searchnpc.test=function()
	if room_obj[npc.name]~=nil then
		npc.id=room_obj[npc.name].id
		testnpcid()
		_roomid=searchfor["nextroom"]
		print(_roomid)
		searchfor["end"]("ok")
	else
		searchfor["next"](getroomexits(searchfor["nextroom"],true))
	end
end

npcinpath={}
npcinpath["ok"]=nil
npcinpath["fail"]=nil

do_npcinpath=function(_path,npcinpath_ok,npcinpath_fail)
	npcinpath["ok"]=npcinpath_ok
	npcinpath["fail"]=npcinpath_fail
	EnableTriggerGroup("npc",true)
	do_steppath(_path,npcinpath.step,npcinpath_end_fail,npcinpath_end_fail,npcinpath_end_fail)
end

npcinpath["end"]=function(s)
	EnableTriggerGroup("npc",false)
	if ((s~="")and(s~=nil)) then
		call(npcinpath[s])
	end
	npcinpath["ok"]=nil
	npcinpath["fail"]=nil
end

npcinpath_end_ok=function()
	npcinpath["end"]("ok")
end

npcinpath_end_fail=function()
	npcinpath["end"]("fail")
end
npcinpath.step=function()
	print(_roomid)
	print(steppath["nextroom"])
	if room_obj[npc.name]~=nil then
		npc.loc=_roomid
		npc.id=room_obj[npc.name].id
		testnpcid()
		print("find"..npc.name.."@"..tostring(_roomid))
		_roomid=steppath["nextroom"]
		steppath["end"]()
		go(npc.loc,npcinpath["ok"],npcinpath["fail"])
		npcinpath["end"]()
	else
		steppath["next"]()
	end
end

npc_killme=function(n,l,w)
	if _hooklist[hooks.killme]~= nil then
		_hooklist[hooks.killme](w[2])
	end
end

testnpcid=function(obj)
	if npc.id==nil then
		npc.id=getcnname(npc.name)
	end
end