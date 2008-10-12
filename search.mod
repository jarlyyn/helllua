exitback={east="w",e="w",south="n",s="n",west="e",w="e",north="s",n="s",southeast="nw",se="nw",southwest="ne",sw="ne",northeast="sw",ne="sw",northwest="se",nw="se",eastup="wd",eu="wd",eastdown="wu",ed="wu",southup="nd",su="nd",southdown="nu",sd="nu",westup="ed",wu="ed",westdown="eu",wd="eu",northup="sd",nu="sd",northdown="su",nd="su",up="d",u="d",down="u",d="u",enter="out",out="enter",cross="cross"}

_searchdepth=6 --搜索深度

do_search=function(fstep,ffail)
	searchfor["init"]()
	hook_step(fstep)
	hook_searchfrofail(ffail)
	run("unset brief;l")
end


searchfor={}
searchfor["del"]=function()
	hook_step(nil)
	hook_searchfrofail(nil)
	EnableTriggerGroup("search",false)
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
	_searchforcallbackfaild=nil
	EnableTriggerGroup("search",true)
end
searchfor["next"]=function(exit)
	if (_searchfordata[_searchforlevel]==nil) then
		_searchfordata[_searchforlevel]={}
		_searchforindex[_searchforlevel]=0
		_searchforcount[_searchforlevel]=0
		for k,v in pairs(exit) do
			if (exitback[v]~=nil) then
				_searchforcount[_searchforlevel]=_searchforcount[_searchforlevel]+1
				_searchfordata[_searchforlevel][_searchforcount[_searchforlevel]]=v
			end
		end
	end
	_searchforindex[_searchforlevel]=_searchforindex[_searchforlevel]+1	
	if ((_searchforindex[_searchforlevel]>_searchforcount[_searchforlevel])or(_searchforlevel>_searchdepth)) then
		if (_searchforlevel==1) then
			callhook(_hook_searchfrofail)
			searchfor["del"]()
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
	run(searchfor["step"])		
end

xiaoerguard=function(name, line, wildcards)
	_searchforlevel=_searchforlevel-1	
	searchfor["next"](nil)
end