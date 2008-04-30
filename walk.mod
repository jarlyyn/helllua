assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()

_roomid=-1
_roomname=""
_exits=""
_troomname=nil
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

walk_on_room=function (name, line, wildcards)
	_troomname=wildcards[1]
end

walk_on_stepfail=function (name, line, wildcards)
	_roomid=-1
	callhook(_hook_stepfail)
end

walk_on_room1=function (name, line, wildcards)
	if (_troomname) then
		_roomname=_troomname
	else
		_roomname=wildcards[2]
	end
	_exits=wildcards[5]
	_troomname=nil
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
	run("set brief")
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
		run("set brief")
		searchfor["del"]()
		_roomid=rm[2]
		go(walk["to"])
	end
end

walk_locate_fail=function()
	run("set brief")	
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