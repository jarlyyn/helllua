_hooklist={hook_step,hook_searchfrofail,hook_stepfail,hook_flyfail}

unhook=function()
	for i, h in pairs (_hooklist) do
		h(nil)
	end 
end

callhook=function(hook)
	if (hook~=nil) then 
		hook() 
	end
end

-- �õ�������ڵĹ��ӣ��ѵõ�ȷ�еķ�����
hook_step=function(hook)
	_hook_step=hook
end

hook_searchfrofail=function(hook)
	_hook_searchfrofail=hook
end

hook_stepfail=function(hook)
	_hook_stepfail=hook
end

hook_flyfail=function(hook)
	_hook_flyfail=hook
end