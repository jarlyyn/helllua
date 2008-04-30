assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()

_roomid=-1
_roomname=""
_exits=""
_troomname=nil
_afterwalk=nil
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
walk["del"]=function()
	_stepcallback=nil
end

walk_on_room=function (name, line, wildcards)
	_troomname=wildcards[1]
end

walk_on_room1=function (name, line, wildcards)
	if (_troomname) then
		_roomname=_troomname
	else
		_roomname=wildcards[2]
	end
	_exits=wildcards[5]
	_troomname=nil
	if (_stepcallback~=nil) then _stepcallback() end;
end
go=function (to)
	walk["to"]=to
	if (_roomid<0) then
		run("unset brief")
		do_search(walk_locate_step,walk_locate_fail)
		return
	end
	_stepcallback=walk_on_step
	run("set brief")
	walk["path"]=mushmapper.getpath(_roomid,to,1)
	print(walk["path"])
	walk["index"]=0
	walk["data"]=convpath(walk["path"])
	walk["step"]=nil
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
		if (_afterwalk) then _afterwalk() end
		walk["del"]()
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
	print(1)
	exits={mushmapper.getexits(room)}
	print(2)
	while (i<exits[1]) do
		i=i+1
		if (dir==exits[i*2]) then return exits[i*2+1] end
	end
	return room
end

convpath=function(path)
	local i=0
	_convpath={}
	re = rex.new("([^;]*)")
	n=re:gmatch(path,function (m, t)
		print(m)
		i=i+1
		_convpath[i]=m
	end)
	return _convpath
end