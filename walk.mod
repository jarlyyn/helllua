assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()


_roomid=-1
_roomname=""
_exits=""
walk={}
walk["to"]=-1
walk["path"]=""
walk["data"]={}
walk["index"]=0
walk["step"]=0
walk["open"]=mushmapper.openmap(GetInfo(67).."rooms_all.h")
if (walk[open]==0) then 
	print "文件未找到，请检查设置"
end
walk["end"]=function(s)
	hook_stepfail(nil)
	hook_step(nil)
	hook_flyfail(nil)
	if ((s~="")and(s~=nil)) then callhook(walk[s]) end
	walk["ok"]=nil
	walk["fail"]=nil
end

walk["stop"]=function(hook)
	if ((_hook_step==nil)and(hook~=nil)) then
		walk["end"]()
		hook()
		return
	end
	walk["ok"]=nil
	walk["fail"]=nil
	steptrace(walk["step"])
	hook_step(hook)
end

walk_stop_to=function()
	do_walk(walk["to"],walk["ok"],walk["fail"])
end

walk["stopto"]=function(to,walk_ok,walk_fail)
	walk["to"]=to
	walk["ok"]=walk_ok
	walk["fail"]=walk_fail
	walk["stop"](walk_stop_to)
end

walk_on_busy=function(name, line, wildcards)
	if ((walk["step"]~=nil)and(_hook_step~=nil)) then
		DoAfterSpecial(1,"run("..'"'..walk["step"]..'")',12)
	end
end

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
	callhook(_hook_stepfail)
end

walk_on_room1=function (name, line, wildcards)
	_exits=wildcards[2]
	callhook(_hook_step)
end
do_walk=function (to,walk_ok,walk_fail)
	walk["to"]=to
	walk["ok"]=walk_ok
	walk["fail"]=walk_fail
	
	if (_roomid<0) then
		do_search(walk_locate_step,walk_locate_fail)
		return
	end

	if (_roomid==walk["to"]) then 
		walk["end"]("ok")
		return
	end
	run("set brief 3")
	hook_step(walk_on_step)
	hook_stepfail(walk_on_stepfail)
	hook_flyfail(walk["flyfail"])
	walk["path"]=mushmapper.getpath(_roomid,to,1)
	if (walk["path"]=="") then
		walk["end"]("fail")
		return
	end
	print(walk["path"])
	walk["index"]=0
	walk["data"]=convpath(walk["path"])
	walk["step"]=nil
	hook_stepfail(walk["stepfail"])
	walk_on_step()
end

walk["stepfail"]=function()
	do_search(walk_locate_step,walk_locate_fail)
end

walk["flyfail"]=function()
	walk["path"]=mushmapper.getpath(_roomid,walk["to"],0)
	if (walk["path"]=="") then
		walk["end"]("fail")
		return
	end
	print(walk["path"])
	walk["index"]=0
	walk["data"]=convpath(walk["path"])
	walk["step"]=nil
	hook_stepfail(walk["stepfail"])
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
	local rm={mushmapper.getroomid(_roomname)}
	if (rm[1]~=1) then
		searchfor["next"](getexits(_exits))
	else
		run("set brief 3")
		searchfor["del"]()
		_roomid=rm[2]
		go(walk["to"])
	end
end

walk_locate_fail=function()
	run("set brief 3")	
end

walk_on_step=function()
	walk["index"]=walk["index"]+1
	steptrace(walk["step"])
	if (walk["data"][walk["index"]]==nil) then
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
	exits={mushmapper.getexits(room)}
	while (i<exits[1]) do
		i=i+1
		if (dir==exits[i*2]) then return exits[i*2+1] end
	end
	return room
end

walk_on_flyfail=function ()
	callhook(_hook_flyfail)
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