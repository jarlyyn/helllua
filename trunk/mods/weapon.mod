weapon=function(wn)
	weaponid=GetVariable("weapon2")
	if weaponid==nil then weaponid="" end
	if wn==0 then
		weapon1(false)
		weapon2(false)
	elseif wn==2 then
		if weaponid=="" then return end
		weapon1(false)
		weapon2(true)
	elseif wn==3 then
		weapon1(true)
		weapon2(true)
	else
		weapon2(false)
		weapon1(true)
	end
end

weapon1=function(wield)
	weaponid=GetVariable("weapon")
	if weaponid=="" or weaponid==nil then return end
	if wield==false then
		run ("unwield "..weaponid..";remove "..weaponid)
	else
		run ("wield "..weaponid..";wear "..weaponid)
	end
end

weapon2=function(wield)
	weaponid=GetVariable("weapon2")
	if weaponid=="" or weaponid==nil then return end
	if wield==false then
		run ("unwield "..weaponid..";remove "..weaponid)
	else
		run ("wield "..weaponid..";wear "..weaponid)
	end
end

weapon1dru=100
weapon2dru=100
weapondru=function()
	weapon1dru=100
	weapon2dru=100
	weaponid=GetVariable("weapon")
	weaponid2=GetVariable("weapon2")
	if weaponid~="" and weaponid~=nil then
		catch("weapon1dru","look "..weaponid)
	end
	if weaponid2~="" and weapon2id~=nil then
		catch("weapon2dru","look "..weapon2id)
	end
end

weapon1_dru=function(n,l,w)
	weapon1dru=tonumber(w[1])
end
weapon2_dru=function(n,l,w)
	weapon2dru=tonumber(w[1])
end

repair={}
repair["ok"]=nil
repair["fail"]=nil
repair["weapon"]=""
do_repair=function(w,repair_ok,repair_fail)
	repair["weapon"]=w
	repair["ok"]=repair_ok
	repair["fail"]=repair_fail
	go(66,repair.arrive,repair_end_fail)
end

repair["arrive"]=function()
	busytest(repair.arrivecmd)
end

repair.arrivecmd=function()
	run("repair "..repair["weapon"]..";repair "..repair["weapon"])
	busytest(repair_end_ok)
end

repair["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(repair[s])
	end
	repair["ok"]=nil
	repair["fail"]=nil
end

repair_end_ok=function()
	repair["end"]("ok")
end

repair_end_fail=function()
	repair["end"]("fail")
end

checkrepair=function(check_ok,check_fail)
	if weapon1dru<30 then
		do_repair(GetVariable("weapon"),check_ok,check_fail)
	elseif weapon2dru<30 then
		do_repair(GetVariable("weapon2"),check_ok,check_fail)
	else
		return false
	end
	return true
end


