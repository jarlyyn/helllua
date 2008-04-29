assert  (package.loadlib ("mapper.dll","luaopen_mapper")) ()

_roomid=-1
_roomname=""
_exits=""
_troomname=nil
walk={}
walk["to"]=-1
walk["path"]=""
walk["open"]=mushmapper.openmap(GetInfo(67).."rooms_all.h")

if (walk[open]==0) then 
	print "文件未找到，请检查设置"
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
	if (_searchforcallbackstep~=nil) then _searchforcallbackstep() end;
end
go=function (to)
	walk["to"]=to
	if (_roomid<0) then
		run("unset brief")
		do_search(walk_locate_step,walk_locate_fail)
		return
	end
	run("set brief")
	walk["path"]=mushmapper.getpath(_roomid,to,1)
	print(_roomid..walk["path"])
	run(walk["path"])
	_roomid=to
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