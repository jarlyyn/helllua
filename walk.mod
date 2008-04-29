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
	print(_roomname)
	print(_exits)
	_troomname=nil
end
go=function (to)
	if (_roomid<0) then
		walk["to"]=to
		local fr={mushmapper.getroomid(_roomname)}
		if (fr[1]~=1) then
			print("定位失败")			
			return
		else
			_roomid=fr[2]
		end
	run("unset brief")
	walk["path"]=mushmapper.getpath(_roomid,to,1)
	print(_roomid..walk["path"])
	run(walk["path"])
	end
end