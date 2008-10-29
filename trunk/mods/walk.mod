loadmod("blocker.mod")
walkend=nil
walking={}

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
	hook(hooks.steptimeout,nil)
	if (not(hashook(hooks.step))and(thook~=nil)) then
		walk["end"]()
		thook()
		return
	end
	call(walkend)
	walkend=nil
	walk["ok"]=nil
	walk["fail"]=nil
	steptrace(walk["step"])
	hook(hooks.step,thook)
end

walk_stop_to=function()
	do_walk(walk["to"],walkstoptook,walkstoptofail)
	walkstoptook=nil
	walkstoptofail=nil
end
walkstoptook=nil
walkstoptofail=nil
walk["stopto"]=function(to,walk_ok,walk_fail)
	walk["to"]=to
	walkstoptook=walk_ok
	walkstoptofail=walk_fail
	walk["stop"](walk_stop_to)
end

walk["npc"]=function(npc,walk_ok,walk_fail)
	if npcs[npc]==nil then
		print("无法找到npc "..npc ..",请检查npcs.ini")
		return
	end
	walk["to"]=npcs[npc]["loc"]
	walk["ok"]=walk_ok
	walk["fail"]=walk_fail
	walk["stop"](walk_stop_to)

end
walk_on_busy=function(name, line, wildcards)
	if walking==nil then return end
	if ((walking["step"]~=nil)and(hooks.step~=nil)) then
		if wildcards[2]=="突然发现眼前的景象有些迷乱" then
			run(walking["step"])			
		elseif wildcards[2]=="太累了，还是休息一会儿吧" then
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
do_walk=function (to,walk_ok,walk_fail)
	walking=walk
	initmaze()
	walk["to"]=to
	walk["ok"]=walk_ok
	walk["fail"]=walk_fail
	walkend=walk["end"]
	if (_roomid==-1) then
		run("unset brief")
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
	hook(hooks.stepfail,walk_on_stepfail)
	hook(hooks.flyfail,walk["flyfail"])
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
	do_search(walk_locate_step,walk_locate_fail,walk["ok"],walk["fail"])
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
	local rm={mapper.getroomid(_roomname)}
	if (rm[1]~=1) then
		searchfor["next"](getexits(_exits))
	else
		run("set brief 3")
		walk["ok"]=searchfor["ok"]
		walk["fail"]=searchfor["fail"]
		searchfor["end"]()
		_roomid=rm[2]
		do_walk(walk["to"],walk["ok"],walk["fail"])
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

getexitroom=function (room,dir)
	local exits={}
	local i=0
	local tdir=""
	local texit=""
	if room<0 then return -1 end
	exits={mapper.getexits(room)}
	while (i<exits[1]) do
		i=i+1
		tdir=dir
		texit=exits[i*2]
		if #tdir > #texit then
			texit=texit.."*"
		elseif #tdir < #texit then
			tdir=tdir.."*"
		end
		if (tdir==texit) then return exits[i*2+1] end
	end
	return -1
end

getroomexits=function (room)
	local exits={}
	local i=0
	local roomexits={}
	if room<0 then return nil end
	exits={mapper.getexits(room)}
	while (i<exits[1]) do
		i=i+1
		roomexits[i]=exits[i+i]
	end
	return roomexits
end

walk_on_flyfail=function (n,w,l)
	if w[2] =="你已经超过17岁了，无法再使用这个指令回到客店了。" then
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
maze["沙漠"]=function()
	eatdrink()
	hp()
	mazestep="s"
	busytest(mazetest["沙漠"])
end
mazetest["沙漠"]=function()
	if testneili() then
		dazuo(maze["沙漠"])
	else
		run(mazestep)
	end
end
maze["大沙漠"]=function()
	eatdrink()
	hp()
	if mazestep=="w" or mazestep=="w." then
		mazestep="w."
	elseif mazestep=="home" or mazestep=="home." then
		mazestep="home."
	else
		mazestep="e."
	end
	busytest(mazetest["大沙漠"])
end
mazetest["大沙漠"]=function()
	if testneili() then
		dazuo(maze["大沙漠"])
	else
		run(mazestep)
	end
end
maze["南疆沙漠"]=function()
	eatdrink()	
	if ((mazestep=="sw")or(mazestep=="sw.")) then
		mazestep="sw"
	else
		mazestep="ne."
	end
	if (mazestep=="sw")and(mazecount<8) then
		run("sw")
		mazecount=mazecount+1
	else
		run("ne")
	end
end
maze["戈壁滩"]=function()
	eatdrink()
	if(mazestep=="w")or(mazestep=="w.") then
		mazestep="w."
		if(mazecount<2) then
			 run("w")
		elseif (mazecount%2)==0 then
			run("n")
		else
			run("w")
		end
	else
		mazestep="e."
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
