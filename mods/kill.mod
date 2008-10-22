kill={}
kill["ok"]=nil
kill["fail"]=nil
kill.npc=""
pfm=function()
	pfm_skill=GetVariable("pfm")
	if pfm_skill=="" or pfm ==nil then return end
	if pfm_skill=="shot" then
		run("shot "..kill.npc.." with arrow")
	else
		run(pfm_skill)
	end
end
fightpreper=function()
	if GetVariable("pfm")=="shot" then
		run("hand bow")
	end
	run("yun powerup;yun shield")
end

do_kill=function(npc,kill_ok,kill_fail)
	kill["ok"]=kill_ok
	kill["fail"]=kill_fail
	kill.npc=npc
	hook(hooks.fight,pfm)
	hook(hooks.hurt,pfm)
	busytest(kill.cmd)
end

kill["end"]=function(s)
	hook(hooks.fight,nil)
	hook(hooks.hurt,nil)
	if ((s~="")and(s~=nil)) then
		call(kill[s])
	end
	kill["ok"]=nil
	kill["fail"]=nil
end

kill_end_ok=function()
	kill["end"]("ok")
end

kill_end_fail=function()
	kill["end"]("fail")
end
kill.cmd=function()
	run("yun recover")
	npchere(kill.npc,"kill "..kill.npc)
	busytest(kill.test)
end

kill.test=function()
	if npc.nobody==1 then
		kill_end_fail()
	else
		busytest(kill_end_ok)
	end
end