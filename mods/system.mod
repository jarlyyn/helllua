logable=true

logdelaysec=1
on_disconnect=function()
	if ((logable==true)and(not(quest.stop and (quest.name~="mq" or masterquest.die~=false)))) then
		AddTimer("login",0,0,logdelaysec,"",17445,"Connect")
	end
	logdelaysec=1
end
idre=rex.new("^.*\\\\(?<id>[^-.]+)(-(?<passwd>[^-.]+)){0,1}")
getidpass=function()
	if me.id==nil or me.id=="" then
		s,e,t=idre:match(GetInfo(54))
		if t==nil then return end
		me.id=t.id
		if t.passwd then me.passwd=t.passwd end
	end
end
login=function()
	_passwd=GetVariable("passwd")
	if GetVariable("id")~=nil and GetVariable("id")~=""then
		me.id=GetVariable("id")
	end
	if (_passwd==nil)or(_passwd=="") then
		if me.passwd ~=nil then
			_passwd=me.passwd
		else
			print("�޷��ҵ���������.\nע��,���޸�mcl�ļ�Ϊ ����ʺ���.mcl ���� ����ʺ�-�������.mcl\n����bao.mcl���� bao-123456.mcl.\n����ļ�����û��������Ϣ,���ڱ���passwd������.")
			return
		end
	end
	run(me.id)
	run(_passwd)
	run("y")
end

system_login=function(name, line, wildcards)
	getidpass()
	EnableTriggerGroup("log",true)
	if (not logable) then return end
		login()
end

logdelay=function(n,l,w)
	print("ʮ����½,���Ե�")
	logdelaysec=10
end
system_logok=function(name,line,wildcards)

	logable=true
	EnableTriggerGroup("log",false)
	print("����Զ�����״̬")
	if _hooklist[hooks.logok]~=nil then
		callhook(hooks.logok,true)
	else
		resume()
	end

end

on_steptimeout=function()
	callhook(hooks.steptimeout)
end

on_hurt=function(name,line,wildcards)
	callhook(hooks.hurt)
end

recon=function()
	DiscardQueue()
	Disconnect()
	DeleteTemporaryTimers()
	on_disconnect()
end

on_faint=function(name,line,wildcards)
	if hashook(hooks.faint) then
		callhook(hooks.faint)
	else
		recon()
	end
end

on_faint1=function(name,line,wildcards)
	if hashook(hooks.faint1) then
		callhook(hooks.faint1)
	else
		discon()
	end
end

discon=function()
	logable=false
	if posioned then
		logable=false
	end
	Disconnect()
end

catch=function(trigrp,command)
	trigrpon(trigrp)
	run(command)
	trigrpoff(trigrp)
end
busytestdelay=1
busytestcmd="enchase bao"
busytest=function(busyhook,t,...)
	if t==nil then t=1 end
	busytestdelay=t
	if hashook(hooks.isbusy) then
		hook(hooks.isbusy,busyhook,...)
	else
		hook(hooks.isbusy,busyhook,...)
		run("enchase bao")
	end
end

delay=function(t,busyhook,...)
	if hashook(hooks.isbusy) then
		hook(hooks.isbusy,busyhook,...)
	else
		hook(hooks.isbusy,busyhook,...)
		DoAfterSpecial(t,'run(\"enchase bao\")',12)
	end
end

system_trigrpoff=function(name, line, wildcards)
		EnableTriggerGroup(wildcards[2],false)
end

trigrpoff=function(str)
	run("set no_more trigrpoff "..str)
end
system_trigrpon=function(name, line, wildcards)
		EnableTriggerGroup(wildcards[2],true)
end
trigrpon=function(str)
	run("set no_more trigrpon "..str)
end

system_isbusy=function(name, line, wildcards)
	if hooks.isbusy~=nil then
		DoAfterSpecial(busytestdelay,'run(\"enchase bao\")',12)
	end
end

system_onfight=function(name, line, wildcards)
	if hashook(hooks.isbusy) then
		DoAfterSpecial(1,'run(\"enchase bao\")',12)
	end
	if hashook(hooks.fight) then
		callhook(hooks.fight)
	else
		recon()
	end
end

system_nobusy=function(name, line, wildcards)
	callhook(hooks.isbusy,true)
end

system_infoend=function(name, line, wildcards)
	callhook(hooks.infoend,true)
end

infoend=function(func)
	hook(hooks.infoend,func)
	run("set no_more infoend")
end

_stop=false
runre=rex.new("([^;*\\\\]+)")
run=function(str)
	ResetTimer("on_steptimeout")
	if ((str=="")or(str==nil)) then return end
	SetSpeedWalkDelay(math.floor(1000/cmd_limit))
	_cmds={}
	local i=0
	n=runre:gmatch(str,function (m, t)
		i=i+1
		_cmds[i]=m
	end)
	if (_cmds==nil) then return end
	for i, cmd in pairs (_cmds) do
		if cmd=="#gift" then
			if chatroom~=nil then
				cmd="enter "..chatroom
			end
		end
		Queue(cmd,walkecho)
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
	re=rex.new("(((��|һ|��|��|��|��|��|��|��|��|ʮ|��|ǧ|��)*)(λ|֧|��|��|��|ֻ|��|��|ö|��|��|��|��|��|��|��)){0,1}(.*)")
	a,b,matchs=re:match(str)
	if matchs~=nil then
		if matchs[2]~=false then
			num=ctonum(matchs[2])
			str=matchs[5]
		end
	end
	return str,num
end


systemtri={system=true,user=true}
inittri=function()
print("��ʼ��������...")
	tri=GetTriggerList()
	for k,v in ipairs(tri) do
		if systemtri[GetTriggerInfo(v,26)]==true then
			EnableTrigger(v,true)
		else
			EnableTrigger(v,false)
		end
	end
end
inittri()


getnum=function(num)
	if (num==nil) then num=0 end
	return num
end

on_unwield=function(n,l,w)
	weapon(0)
end

kanbush=function(n,l,w)
	weapon(3)
	if walking==nil then return end
	if ((walking["step"]~=nil)and(hooks.step~=nil)) then
		busytest(kanbushcmd)
	end
end

kanbushcmd=function()
	weapon(1)
end

on_getweapon=function()
	_getweaponcmd=""
	weaponid=GetVariable("weapon")
	weapon2id=GetVariable("weapon2")
	if weaponid~=nil then _getweaponcmd="get "..weaponid end
	if masterweapon[weaponid]~=nil then
		if weapon2id ~=nil then
			_getweaponcmd=_getweaponcmd..";get "..weapon2id
		end
	end
	run (_getweaponcmd)
	weapon(1)
end


