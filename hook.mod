hooks={}
hooks.step="step"
--每进入一个新房间的hook
hooks.searchfrofail="searchfrofail"
--search失败的hook
hooks.isbusy="isbusy"
--是否busy的hook
hooks.infoend="infoend"
--信息结束的hook
hooks.stepfail="stepfail"
--步近失败的hook
hooks.flyfail="flyfail"
--fly失败的hook
hooks.logok="logok"
--登陆成功后的hook
hooks.hurt="hurt"
--轻伤
hooks.faint="faint"
--重伤
hooks.faint1="faint1"
--昏迷

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