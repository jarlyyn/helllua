loadmod("blocker.mod")
walkend=nil
walking=nil

_roomid=-1
_roomname=""
_exits=""
walk={}
walk["to"]=-1
walk["path"]=""
walk["data"]={}
walk["index"]=0
walk["step"]=0

walk["end"]=function(s)
	walking=nil
	hook(hooks.stepfail,nil)
	hook(hooks.step,nil)
	hook(hooks.flyfail,nil)
	if ((s~="")and(s~=nil)) then
		call(walk[s])
	end
	walk["ok"]=nil
	walk["fail"]=nil
end
walk_end_fail=function()
	walk["end"]("fail")
end

walk["stop"]=function(thook)
	if (not(hashook(hooks.step))) then
		call(thook)
		return
	end
	walkstopstep=walking.step
	walkstopthook=thook
	walk["ok"]=nil
	walk["fail"]=nil
	hook(hooks.step,walk_stop_hook)
	if hashook(hooks.steptimeout) then
		hook(hooks.steptimeout,walkstopthook)
	end
end

walk_stop_hook=function()
	if walkstopstep~=nil then
		steptrace(walkstopstep)
	end
	call(walkstopthook)
end


walk_stop_to=function()
	do_walk(walkstoptoto,walkstoptook,walkstoptofail)
	walkstoptook=nil
	walkstoptofail=nil
end
walkstoptook=nil
walkstoptofail=nil
walk["stopto"]=function(to,walk_ok,walk_fail)
	walkstoptoto=to
	walkstoptook=walk_ok
	walkstoptofail=walk_fail
	walk["stop"](walk_stop_to)
end

walk["npc"]=function(npc,walk_ok,walk_fail)
	if npcs[npc]==nil then
		print("�޷��ҵ�npc "..npc ..",����npcs.ini")
		return
	end
	go(npcs[npc]["loc"],walk_ok,walk_fail)
end
walk_on_busy=function(name, line, wildcards)
	if walking==nil then return end
	if ((walking["step"]~=nil)and(hooks.step~=nil)) then
		if wildcards[2]=="��ͻȻ������ǰ�ľ�����Щ����" then
			run(walking["step"])
		elseif wildcards[2]=="̫���ˣ�������Ϣһ�����" then
			DoAfterSpecial(1,"run('yun recover;'.."..'"'..walking["step"]..'")',12)
		else
			DoAfterSpecial(1,"run("..'"'..walking["step"]..'")',12)
		end
	end
end
walk_onnoweapon=function(n,l,w)
	weapon(0)
	if ((walking["step"]~=nil)and(hooks.step~=nil)) then
			run(walking["step"])
	end
end
room_obj={}
walk_on_room=function (name, line, wildcards,styles)
	__textindex=1
	if ((#wildcards[1])~=0)and((#wildcards[1])==styles[1]["length"]) then
		__textindex=2
	end
	if ((#styles)==__textindex)and(styles[__textindex]["textcolour"]==ColourNameToRGB("Cyan")) then
		_roomname=((styles[__textindex]["text"]))
	end
end



walk_on_stepfail=function (name, line, wildcards)
	_roomid=-1
	callhook(hooks.stepfail)
end

walk_on_room1=function(name, line, wildcards)
	_exits=wildcards[2]
	callhook(hooks.step)
	room_obj={}
	EnableTriggerGroup("roomobj",true)
end
walklocateto=0
walklocateok=nil
walklocatefail=nil
do_walk=function (to,walk_ok,walk_fail)
	walking=walk
	initmaze()
	walk["to"]=to
	walk["ok"]=walk_ok
	walk["fail"]=walk_fail
	walkend=walk["end"]
	if (_roomid==-1) then
		run("unset brief")
		walklocateto=to
		walklocateok=walk_ok
		walklocatefail=walk_fail
		EnableTriggerGroup("locate",true)
		do_search(walk_locate_step,walk_locate_fail,walk_ok,walk_fail)
		return
	end
	if (to==-2) then
		do_nosafe(walk_ok,walk_fail)
		return
	end

	if (_roomid==walk["to"]) then
		walk["end"]("ok")
		return
	end
	run("set brief 3")
	hook(hooks.step,walk_on_step)
	hook(hooks.stepfail,walk.stepfail)
	hook(hooks.flyfail,walk["flyfail"])
	hook(hooks.steptimeout,nil)
	walk["path"]=mapper.getpath(_roomid,to,1)
	if (walk["path"]=="") then
		walk["end"]("fail")
		return
	end
	print(walk["path"])
	walk["index"]=0
	walk["data"]=convpath(walk["path"])
	walk["step"]=nil
	hook(hooks.stepfail,walk["stepfail"])
	walk_on_step()
end

walk["stepfail"]=function()
	do_walk(walk["to"],walk["ok"],walk["fail"])
end

walk["flyfail"]=function()
	walk["path"]=mapper.getpath(_roomid,walk["to"],0)
	if (walk["path"]=="") then
		walk["end"]("fail")
		return
	end
	print(walk["path"])
	walk["index"]=0
	walk["data"]=convpath(walk["path"])
	walk["step"]=nil
	hook(hooks.stepfail,walk["stepfail"])
	walk_on_step()
end

getexits=function(exit)
	exits={}
	i=0
	re = rex.new ("(\[A-Za-z\]+)")
	re:gmatch (exit, function (m, t)
		 i=i+1
		exits[i]=m
	 end )
	return exits
end

walk_locate_step=function()
	local rm=mapper.getroomid(_roomname)
	if getnum(_roomid)>-1 then
		rm={}
		rm[1]=_roomid
	end
	if (#rm~=1) then
		searchfor["next"](getexits(_exits))
	else
		EnableTriggerGroup("locate",false)
		run("set brief 3")
		walk["ok"]=searchfor["ok"]
		walk["fail"]=searchfor["fail"]
		searchfor["end"]()
		_roomid=rm[1]
		go(walklocateto,walklocateok,walklocatefail)
	end
end

walk_locate_fail=function()
	run("set brief 3")
end

walk_on_step=function()
	if _roomname~=nil and _roomname~="" then
		if maze[_roomname]~=nil then
			if _roomname~=mazename then
				mazename=_roomname
				walk["index"]=walk["index"]+1
				steptrace(walk["step"])
			end
			mazestep=walk["data"][walk["index"]]
			maze[_roomname]()
			return
		end
	end
	walk["index"]=walk["index"]+1
	if mazestep~="" and mazestep~=nil then
		steptrace(mazestep)
	else
		steptrace(walk["step"])
	end
	initmaze()
	if (walk["data"][walk["index"]]==nil) then
		walk["end"]("ok")
		return
	end
	if string.sub(walk["data"][walk["index"]],1,4)=="#loc" then
			walk["end"]("ok")
			return
	end
	walk["step"]=walk["data"][walk["index"]]
	run(walk["step"])
end

steptrace=function(dir)
	if ((dir=="")or(dir==nil)) then return end
	if (_roomid~=-1) then  _roomid=getexitroom(_roomid,dir) end
end


walk_on_flyfail=function (n,w,l)
	if w[2] =="���Ѿ�����17���ˣ��޷���ʹ�����ָ��ص��͵��ˡ�" then
		me.age=18
		setflylist()
	end
	callhook(hooks.flyfail)
end



convpath=function(path)
	local i=0
	_convpath={}
	re = rex.new("([^;]+)")
	n=re:gmatch(path,function (m, t)
		i=i+1
		_convpath[i]=m
	end)
	return _convpath
end

on_obj=function(name, line, wildcards)
	_item,num=getitemnum(wildcards[1])
	if room_obj[wildcards[2]]~=nil then
		room_obj[wildcards[2]]["num"]=room_obj[wildcards[2]]["num"]+num
	else
		room_obj[wildcards[2]]={num=num,id=wildcards[2]}
	end
	room_obj[_item]=room_obj[wildcards[2]]
end
on_objend=function(name, line, wildcards)
	EnableTriggerGroup("roomobj",false)
end
walk_npc=function(n,l,w)
	room_obj[w[2]]={num=1,id=nil}
end

walk_wdfail=function(n,l,w)
	familys[me.fam].family="wd2"
	settags()
	callhook(hooks.flyfail)
end
----------------------------------




nosafe={}
nosafe.ok=nil
nosafe.fail=nil
do_nosafe=function(nosafe_ok,nosafe_fail)
	nosafe["ok"]=nosafe_ok
	nosafe["fail"]=nosafe_fail
	EnableTriggerGroup("nosafe",true)
	do_search(nosafe.step,nosafe_end_fail,nosafe_end_ok,nosafe_end_fail)
end
nosafe["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(nosafe[s])
	end
	EnableTriggerGroup("nosafe",false)
	nosafe["ok"]=nil
	nosafe["fail"]=nil
end
nosafe_end_fail=function()
	nosafe["end"]("fail")
end
nosafe_end_ok=function()
	nosafe["end"]("ok")
end
nosafe.step=function()
	run("attack")
end

nosafe_onok=function(n,l,w)
	_roomid=searchfor["nextroom"]
	searchfor["end"]("ok")
end
nosafe_onfail=function(n,l,w)
	searchfor["next"](getroomexits(searchfor["nextroom"]))
end
go=walk["stopto"]

initmaze=function()
	mazename=""
	mazecount=0
	mazestep=""
end
maze={}
mazetest={}
mazestep=""
mazename=""
maze["ɳĮ"]=function()
	eatdrink()
	hp()
	mazestep="s"
	busytest(mazetest["ɳĮ"])
end
mazetest["ɳĮ"]=function()
	if testneili() then
		dazuo(maze["ɳĮ"])
	else
		run(mazestep)
	end
end
maze["��ɳĮ"]=function()
	eatdrink()
	hp()
	if mazestep=="w" or mazestep=="w*" then
		mazestep="w*"
	elseif mazestep=="home" or mazestep=="home*" then
		mazestep="home*"
	else
		mazestep="e*"
	end
	busytest(mazetest["��ɳĮ"])
end
mazetest["��ɳĮ"]=function()
	if testneili() then
		dazuo(maze["��ɳĮ"])
	else
		run(mazestep)
	end
end
maze["�Ͻ�ɳĮ"]=function()
	eatdrink()
	if ((mazestep=="sw")or(mazestep=="sw*")) then
		mazestep="sw"
	else
		mazestep="ne*"
	end
	if (mazestep=="sw")and(mazecount<8) then
		run("sw")
		mazecount=mazecount+1
	else
		run("ne")
	end
end
maze["���̲"]=function()
	eatdrink()
	if(mazestep=="w")or(mazestep=="w*") then
		mazestep="w*"
		if(mazecount<2) then
			 run("w")
		elseif (mazecount%2)==0 then
			run("n")
		else
			run("w")
		end
	else
		mazestep="e*"
		if(mazecount<2) then
			 run("s")
		elseif (mazecount%2)==0 then
			run("e")
		else
			run("s")
		end
	end
		mazecount=mazecount+1
end
gwriver=function(n,l,w)
	if walking==walk then
		run("give 1 silver to chuan fu")
		walk["index"]=walk["index"]+1
		steptrace(walk["step"])
	else
		if walking==steppath then
			steppath["index"]=steppath["index"]+1
			_roomid=steppath["nextroom"]
			if (steppath["index"]>#steppath["path"]) then
				steppath["end"]("ok")
				return
			end
			steppath["step"]=steppath["path"][steppath["index"]]["step"]
			steppath["nextroom"]=getexitroom(_roomid,steppath["step"])
			run("cross")
		end
	end
end

on_locate=function(n,l,w)
	if #n<3 then return end
	local rid=tonumber(string.sub(n,3,#n))
	if rid~= nil then
		_roomid=rid
	end
end
