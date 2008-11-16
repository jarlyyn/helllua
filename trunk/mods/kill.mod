kill={}
kill["ok"]=nil
kill["fail"]=nil
kill.npc=""
pfm=function()
	if me.special["小周天运转"] then run("yun recover") end
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
	if me.special["天神降世"] then run("special power") end
	if me.special["如鬼似魅"] then run("special agile") end
	if me.special["杀气"] then run("special hatred") end

	run("yun recover;yun powerup;yun shield")
end

do_kill=function(npc,kill_ok,kill_fail)
	kill["ok"]=kill_ok
	kill["fail"]=kill_fail
	kill.npc=npc
	hook(hooks.fight,pfm)
	hook(hooks.hurt,pfm)
	kill.cmd()
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
	run("yun recover;yun regenerate")
	if (me.score.xingge=="心狠手辣")or(me.score.xingge=="光明磊落")and(tonumber(GetVariable("neilimin"))>1000) then run("burning") end
	npchere(kill.npc,"kill "..kill.npc)
	fightcuff()
	weapon(1)
	pfm()
	busytest(kill.test)
end

kill.test=function()
	if npc.nobody==1 then
		kill_end_fail()
	else
		busytest(kill_end_ok)
	end
end

fightcuff=function()
	cmd=GetVariable("fightcuff")
	if cmd~=nil and cmd~="" then
		weapon(0)
		run(cmd)
	end
end
