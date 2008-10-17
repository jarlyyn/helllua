exitback={east="w",e="w",south="n",s="n",west="e",w="e",north="s",n="s",southeast="nw",se="nw",southwest="ne",sw="ne",northeast="sw",ne="sw",northwest="se",nw="se",eastup="wd",eu="wd",eastdown="wu",ed="wu",southup="nd",su="nd",southdown="nu",sd="nu",westup="ed",wu="ed",westdown="eu",wd="eu",northup="sd",nu="sd",northdown="su",nd="su",up="d",u="d",down="u",d="u",enter="out",out="enter",cross="cross"}

_searchdepth=5 --搜索深度

do_search=function(fstep,ffail,search_ok,search_fail)
	searchfor["init"]()
	searchfor["ok"]=search_ok
	searchfor["fail"]=search_fail
	walkend=searchfor["end"]
	hook(hooks.step,fstep)
	hook(hooks.searchfrofail,ffail)
	searchfor["nextroom"]=_roomid
	run("l")
end

searchfor={}
searchfor["nextroom"]=0

searchfor["end"]=function(s)
	hook(hooks.step,nil)
	hook(hooks.searchfrofail,nil)
	EnableTriggerGroup("search",false)
	if ((s~="")and(s~=nil)) then 
		call(searchfor[s]) 
	end
	searchfor["ok"]=nil
	searchfor["fail"]=nil
end

searchfor["init"]=function()
	_searchfordata={}
	_searchfordata[1]=nil
	_searchfordata[2]=nil
	_searchfordata[3]=nil
	_searchfordata[4]=nil
	_searchfordata[5]=nil
	_searchfordata[6]=nil--每层的出口数据，一个列表，以层为参数
	_searchforback={}--每层的返回数据，一个列表，以层为参数
	_searchforcount={}--每层的出口总数，一个数字，以层为参数
	_searchforindex={}--每层的当前出口，一个数字，以层为参数
	_searchforlevel=1 --当前层数
	_stepcallback=nil
	searchfor["step"]=0
	_searchforcallbackfaild=nil
	EnableTriggerGroup("search",true)
end
searchfor["next"]=function(exit)
	if searchfor["nextroom"]~=-1 then _roomid=searchfor["nextroom"] end
	if (_searchfordata[_searchforlevel]==nil) then
		_searchfordata[_searchforlevel]={}
		_searchforindex[_searchforlevel]=0
		_searchforcount[_searchforlevel]=0
		for k,v in pairs(exit) do
			if (exitback[v]~=nil) and (exitback[v]~=searchfor["step"]) then
				_searchforcount[_searchforlevel]=_searchforcount[_searchforlevel]+1
				_searchfordata[_searchforlevel][_searchforcount[_searchforlevel]]=v
			end
		end
	end
	_searchforindex[_searchforlevel]=_searchforindex[_searchforlevel]+1	
	if ((_searchforindex[_searchforlevel]>_searchforcount[_searchforlevel])or(_searchforlevel>_searchdepth)) then
		if (_searchforlevel==1) then
			callhook(hooks.searchfrofail)
			searchfor["end"]("fail")
			return
		end				
		searchfor["step"]=_searchforback[_searchforlevel]
		_searchforlevel=_searchforlevel-1	
	else
		searchfor["step"]=_searchfordata[_searchforlevel][_searchforindex[_searchforlevel]]
		_searchforlevel=_searchforlevel+1
		_searchfordata[_searchforlevel]=nil
		_searchforback[_searchforlevel]=exitback[searchfor["step"]]
	end
	if _roomid~=-1 then
		searchfor["nextroom"]=getexitroom(_roomid,searchfor["step"])
	else
		searchfor["nextroom"]=-1
	end
	run(searchfor["step"])		
end

xiaoerguard=function(name, line, wildcards)
	searchfor["nextroom"]=getexitroom(searchfor["nextroom"],exitback[searchfor["step"]])
	_searchforlevel=_searchforlevel-1	
	searchfor["next"](nil)
end

steppath={}
do_steppath=function(path,pstep,pfail,path_ok,path_fail)
	steppath["path"]=path
	steppath["ok"]=path_ok
	steppath["fail"]=path_fail
	walkend=steppath["end"]
	steppath["pstep"]=pstep
	steppath["pfail"]=pfail
	do_walk(path[1]["loc"],steppath["arrive"],path_fail)
end
steppath["arrive"]=function()
	hook(hooks.step,steppath["pstep"])
	hook(hooks.searchfrofail,steppath["pfail"])
	steppath["index"]=0
	steppath["step"]=nil
	steppath["nextroom"]=_roomid
	steppath["next"]()
end
steppath["end"]=function(s)
	if ((s~="")and(s~=nil)) then 
		call(steppath[s]) 
	end
	steppath["ok"]=nil
	steppath["fail"]=nil
	hook(hooks.step,nil)
	hook(hooks.searchfrofail,nil)
end

steppath["next"]=function()
	steppath["index"]=steppath["index"]+1
	_roomid=steppath["nextroom"]
	if (steppath["index"]>#steppath["path"]) then
		steppath["end"]("ok")
		return
	end
	steppath["step"]=steppath["path"][steppath["index"]]["step"]
	steppath["nextroom"]=getexitroom(_roomid,steppath["step"])
	run(steppath["step"])		
end

