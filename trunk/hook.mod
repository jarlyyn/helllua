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