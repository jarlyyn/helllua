exitback={east="w",e="w",south="n",s="n",west="e",w="e",north="s",n="s",southeast="nw",se="nw",southwest="ne",sw="ne",northeast="sw",ne="sw",northwest="se",nw="se",eastup="wd",eu="wd",eastdown="wu",ed="wu",southup="nd",su="nd",southdown="nu",sd="nu",westup="ed",wu="ed",westdown="eu",wd="eu",northup="sd",nu="sd",northdown="su",nd="su",up="d",u="d",down="u",d="u",enter="out",out="enter",cross="cross"}

_searchdepth=6 --�������


do_search=function(fstep,ffail)
	searchfor["init"]()
	_stepcallback=fstep
	_searchforcallbackfaild=ffail
	run("l")
end


searchfor={}
searchfor["del"]=function()
	_stepcallback=nil
	_searchforcallbackfaild=nil
end

searchfor["init"]=function()
	_searchfordata={}
	_searchfordata[1]=nil
	_searchfordata[2]=nil
	_searchfordata[3]=nil
	_searchfordata[4]=nil
	_searchfordata[5]=nil
	_searchfordata[6]=nil--ÿ��ĳ������ݣ�һ���б��Բ�Ϊ����
	_searchforback={}--ÿ��ķ������ݣ�һ���б��Բ�Ϊ����
	_searchforcount={}--ÿ��ĳ���������һ�����֣��Բ�Ϊ����
	_searchforindex={}--ÿ��ĵ�ǰ���ڣ�һ�����֣��Բ�Ϊ����
	_searchforlevel=1 --��ǰ����
	_stepcallback=nil
	_searchforcallbackfaild=nil
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
			if (_searchforcallbackfalid~=nil) then _searchforcallbackfalid() end
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
