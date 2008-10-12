busytest=function(busyhook)
	hook_isbusy(busyhook)
	run("guard")
end

system_isbusy=function(name, line, wildcards)
	if _hook_isbusy~=nil then
		DoAfter(1,"guard")
	end
end

system_nobusy=function(name, line, wildcards)
	thook=_hook_isbusy
	_hook_isbusy=nil
	callhook(thook)
end


_stop=false
run=function(str)
	if ((str=="")or(str==nil)) then return end
	_cmds={}
	local i=0
	re=rex.new("([^;.\]+)")
	n=re:gmatch(str,function (m, t)
		i=i+1
		_cmds[i]=m
	end)
	if (_cmds==nil) then return end
	for i, cmd in pairs (_cmds) do
		Queue(cmd,true)
	end 
end

_nums={}
_nums["һ"]=1
_nums["��"]=2
_nums["��"]=3
_nums["��"]=4
_nums["��"]=5
_nums["��"]=6
_nums["��"]=7
_nums["��"]=8
_nums["��"]=9


ctonum=function(str)
	if (#str % 2) ==1 then
		return 0
	end
	result=0
	wan=1
	unit=1
	for i=#str -2 ,0,-2 do
		char=string.sub(str,i+1,i+2)
		if (char=="ʮ") then
			unit=10*wan
			if (i==0) then
				result=result+unit
			elseif _nums[string.sub(str,i-1,i)]==nil then
				result=result+unit
			end
		elseif (char=="��") then
			unit=100*wan
		elseif (char=="ǧ") then
			unit=1000*wan
		elseif (char=="��") then
			unit=10000*wan
			wan=10000
		else
			if _nums[char]~=nil then
				result=result+_nums[char]*unit
			end
		end
	end		
	return result
end

getitemnum=function(str)
	num=1
	re=rex.new("(((һ|��|��|��|��|��|��|��|��|ʮ|��|ǧ|��)*)(֧|��|��|ֻ|��|��|ö|��|��|��|��|��|��)){0,1}(.*)")
	a,b,matchs=re:match(str)
	if matchs~=nil then
		if matchs[2]~=false then
			num=ctonum(matchs[2])
			str=matchs[5]
		end
	end
	return str,num
end


systemtri={system=true,status=true}
inittri=function()
	tri=GetTriggerList()
	for k,v in ipairs(tri) do
		if systemtri[GetTriggerInfo(v,26)]==true then
			EnableTrigger(v,true)
		else
			EnableTrigger(v,false)
		end
	end
end
print("��ʼ��������...")
inittri()


getnum=function(num)
	if (num==nil) then num=0 end
	return num
end