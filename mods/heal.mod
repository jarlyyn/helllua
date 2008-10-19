healyao="jinchuang yao"
heal={}
heal["ok"]=nil
heal["loc"]=0
heal["hp"]=0
checkheal=function(cheal_ok,cheal_fail)
	qixuemin=GetVariable("qixuemin")
	if qixuemin=="" or qixuemin ==nil then
		qixuemin=75
	else
		qixuemin=tonumber(qixuemin)
	end
	if me.hp["qixue%"]<qixuemin then
		do_heal(cheal_ok,cheal_fail)
		return true
	else
		return false
	end
end

do_heal=function(heal_ok,heal_fail)
	heal["ok"]=heal_ok
	heal.fail=heal_fail
	heal.loc=-2
	heal.cmd="yun heal"
	if familys[me.fam]~=nil then
		if familys[me.fam].healcmd~=nil then
			heal.loc=familys[me.fam].dazuoloc
			heal.cmd=familys[me.fam].cmd
		end
	end
	go(heal.loc,heal.arrive,heal_end_fail)
end
heal["end"]=function(s)
	if ((s~="")and(s~=nil)) then 
		call(heal[s]) 
	end
	heal["ok"]=nil
	heal.fail=nil
end
heal_end_fail=function()
	heal["end"]("fail")
end
heal_end_ok=function()
	heal["end"]("ok")
end

heal["arrive"]=function()
	if me.hp["qixue%"]==100 then
		heal["end"]("ok")
		return
	end
	if me.hp["qixue%"]==heal["hp"] then
		if getnum(itemlist[healyao])>0 then
			heal["yao"]()
		else
			item["go"](healyao,1,heal["yao"],heal_end_fail)
		end
	else
		heal.hp=me.hp["qixue%"]
		busytest(heal.go)
	end
end

heal["go"]=function()
	run(heal.cmd)
	busytest(heal.test)
end

heal["test"]=function()
	hp()
	infoend(heal.arrive)	
end

heal["yao"]=function()
	busytest(heal["eatyao"])
end

heal["eatyao"]=function()
	run("eat "..healyao)
	busytest(heal_end_ok)
end
