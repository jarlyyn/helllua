kill={}
kill["ok"]=nil
kill["fail"]=nil
kill.npc=""
pfm=function()
	if me.special["С������ת"] then run("yun recover") end
	pfm_skill=GetVariable("pfm")
	if pfm_skill=="" or pfm ==nil then return end
	if pfm_skill=="shot" then
		if quest.name~="mq" or masterquest.die~=true then
			run("shot "..kill.npc.." with arrow")
		end
	else
		run(pfm_skill)
	end
end
fightpreper=function()
	if GetVariable("pfm")=="shot" then
		run("hand bow")
	end
	if me.special["������"] then run("special power") end
	if me.special["�������"] then run("special agile") end
	if me.special["ɱ��"] then run("special hatred") end
	run(preperskillcmd)
	if GetVariable("fight_preper")~=nil then
		run(GetVariable("fight_preper"))
	end
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
	if (me.score.xingge=="�ĺ�����")or(me.score.xingge=="��������")and(tonumber(GetVariable("nuqimin"))>2000) then run("burning") end
	cmd=GetVariable("fightcuff")
	if cmd==nil or cmd=="" then
		weapon(1)
	end
	npchere(kill.npc,"kill "..kill.npc)
	fightcuff()
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
		weapon(1)
	end
end
