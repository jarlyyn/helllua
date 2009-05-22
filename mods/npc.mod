if stepmaxstep==nil then stepmaxstep=getnum(maxstep) end

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
searchnpc.roomlist={}
do_searchnpc=function(searchnpc_ok,searchnpc_fail)
	npc.loc=-1
	searchnpc["ok"]=searchnpc_ok
	searchnpc["fail"]=searchnpc_fail
	searchnpc.roomlist={}
	EnableTriggerGroup("npc",true)
	doghook()
	if _roomname~=nil and _roomname~="" then
		if maze[_roomname]~=nil then
			searchnpc_end_fail()
			return
		end
	end
	do_search(searchnpc.step,searchnpc_end_fail,searchnpc_end_ok,searchnpc_end_fail,npcsearchmax)
end

searchnpc["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(searchnpc[s])
	end
	dogunhook()
	searchnpc.roomlist={}
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
		--if room_obj[npc.name].id~=nil then
			npc.id=room_obj[npc.name].id
		--else
			--npc.id=""
		--end
		if room_obj[npc.name].id~=nil then
			if string.find(room_obj[npc.name].id,"%s")==nil then
				return
			end
		end
		if _roomname~=nil and _roomname~="" then
			if maze[_roomname]==nil then
				_roomid=searchfor["nextroom"]
			end
		end
		print(_roomid)
		searchfor["end"]("ok")
	else
		searchnpc.roomlist[_roomid]=true
		searchfor["next"](getroomexits(searchfor["nextroom"],true,searchnpc.roomlist))
	end
end

npcinpath={}
npcinpath["ok"]=nil
npcinpath["fail"]=nil
npcinpath["loc"]=-1

do_npcinpath=function(_path,npcinpath_ok,npcinpath_fail,reportonly)
	npcinpath["ok"]=npcinpath_ok
	npcinpath["fail"]=npcinpath_fail
	npcinpath["loc"]=-1
	npcinpath.reportonly=reportonly
	EnableTriggerGroup("npc",true)
	do_steppath(_path,npcinpath.step,npcinpath_end_fail,npcinpath_end_fail,npcinpath_end_fail,stepmaxstep,npcinpath["maxstep"])
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
	print(steppath["nextroom"])
	if _roomname~=nil and _roomname~="" then
		if maze[_roomname]~=nil then
			busytest(npcinpath.testnpc)
			return
		end
	end
	npcinpath.testnpc()
end
npcinpath.testnpc=function()
	if quest.name=="mq" then
		for i,v in pairs(helpfindnpc) do
			if room_obj[v.name]~=nil then
				if room_obj[v.name].id~=nil then
					if string.find(room_obj[v.name].id,"%s")~=nil then
						helpfindnpcfound(i,_roomid,masterquest.city)
					end
				end
			end
		end
		for i,v in pairs(dragons) do
			if room_obj[v]~= nil then
				dragonfound(v,_roomid)
			end
		end
	end
	if room_obj[npc.name]~=nil then
		npc.loc=_roomid
		if room_obj[npc.name].id~=nil then
			if string.find(room_obj[npc.name].id,"%s")==nil then
				return
			end
		end
		npcinpath["loc"]=_roomid
		npc.id=room_obj[npc.name].id
		testnpcid()
		print("find"..npc.name.."@"..tostring(_roomid))
		if _roomname~=nil and _roomname~="" then
			if maze[_roomname]==nil or _roomname~=mazename then
				_roomid=steppath["nextroom"]
			elseif stepmaxstep>1 then
				npcinpathgokillnpc()
				return
			end
		end
		if stepmaxstep<2 then
			npcinpathgokillnpc()
			return
		end
		steppath["next"]()
	else
		steppath["next"]()
	end
end
npcinpathgokillnpc=function()
			steppath["end"]()
			if npcinpath.reportonly~=true then
				go(npc.loc,npcinpath["ok"],npcinpath["fail"])
				npcinpath["end"]()
			else
				npcinpath_end_ok()
			end
end
npcinpath["maxstep"]=function()
	if npcinpath["loc"] >-1 then
		npcinpathgokillnpc()
		return
	end
	steppath["nextmaxstep"]()
end


npc_killme=function(n,l,w)
	if _hooklist[hooks.killme]~= nil then
		_hooklist[hooks.killme](w[2])
	end
end

testnpcid=function(obj)

end
