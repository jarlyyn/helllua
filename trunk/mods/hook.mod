hooks={}
hooks.step="step"
--ÿ����һ���·����hook
hooks.searchfrofail="searchfrofail"
--searchʧ�ܵ�hook
hooks.isbusy="isbusy"
--�Ƿ�busy��hook
hooks.infoend="infoend"
--��Ϣ������hook
hooks.stepfail="stepfail"
--����ʧ�ܵ�hook
hooks.flyfail="flyfail"
--flyʧ�ܵ�hook
hooks.logok="logok"
--��½�ɹ����hook
hooks.hurt="hurt"
--����
hooks.faint="faint"
--����
hooks.faint1="faint1"
--����
hooks.fight="onfight"
--ս��ʱ����.�����Ҫս������ʹ�ô�hook,��Ȼ��reconnect
hooks.steptimeout="steptimeout"
--������һ��ָ��4��󴥷���һ������search֮���step��ʱ
hooks.blocked="blocked"
--step ����ס��hook

hooks.killme="killme"
---��npc��kill��hook,������һ����������kill��npc������
_hooklist={}

hashook=function(str)
	if _hooklist[str] ==nil then
		return false
	else
		return true
	end
end

hook=function(str,callback)
	_hooklist[str]=callback
end

unhookall=function()
	_hooklist={}
end

callhook=function(str,removehook)
	thook=_hooklist[str]
	if removehook==true then
		_hooklist[str]=nil
	end
	call(thook)
end

call=function(func)
	if (func~=nil) then 
		func() 
	end
end