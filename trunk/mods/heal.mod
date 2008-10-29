healyao="jinchuang yao"
heal={}
heal["ok"]=nil
heal["loc"]=0
heal["hp"]=0
getvbquemin=function()
	vbqixuemin=GetVariable("qixuemin")
	if vbqixuemin=="" or vbqixuemin ==nil then
		return 75
	else
		return tonumber(vbqixuemin)
	end
end
checkheal=function(cheal_ok,cheal_fail,forceheal)
	if me.hp["qixue%"]<getvbquemin() then
		do_heal(cheal_ok,cheal_fail,forceheal)
		return true
	else
		return false
	end
end

do_heal=function(heal_ok,heal_fail,forceheal)
	heal["ok"]=heal_ok
	heal.fail=heal_fail
	heal.loc=-2
	heal.cmd="yun heal"
	if familys[me.fam]~=nil and forceheal~=true then
		if familys[me.fam].healcmd~=nil then
			heal.loc=familys[me.fam].dazuoloc
			heal.cmd=familys[me.fam].healcmd
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
	heal.hp=0
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
posioned=false

-------------------------------------------------------

dispel={}
dispel["ok"]=nil
dispel["fail"]=nil

do_dispel=function(dispel_ok,dispel_fail)
	dispel["ok"]=dispel_ok
	dispel["fail"]=dispel_fail
	go(-2,dispel.arrive,dispel_end_fail)
end
dispel.arrive=function()
	busytest(dispel.cmd)
end
dispel.cmd=function()
	run("yun recover;yun dispel")
	busytest(dispel.test)
end

dispel.test=function()
	if posioned then
		busytest(dispel.cmd)
	else
		busy_end_ok()
	end	
end

dispel["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(dispel[s])
	end
	dispel["ok"]=nil
	dispel["fail"]=nil
end

dispel_end_ok=function()
	dispel["end"]("ok")
end

dispel_end_fail=function()
	dispel["end"]("fail")
end

dispel_posioned=function()
	posioned=true
end

dispel_ok=function()
	posioned=false
end

checkdispel=function(dispel_ok,dispel_fail)
	if posioned then
		do_dispel(dispel_ok,dispel_fail)
		return true
	else
		return false
	end
end