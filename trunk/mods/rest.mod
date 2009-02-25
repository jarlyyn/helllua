lastsleep=0
sleepdelay=100


rest={}
testneili=function()
	neilimin=GetVariable("neilimin")
	if neilimin=="" or neilimin ==nil then
		neilimin=0
	else
		neilimin=tonumber(neilimin)
	end
	if me.hp==nil then return true end
	if me.hp.neili==nil then return true end
	return (me.hp.neili< neilimin)
end

checkrest=function(crest_ok,crest_fail,l)
	if testneili() then
		do_rest(crest_ok,crest_fail,l)
		return true
	elseif me.hp.jinli<getnum(tonumber(GetVariable("jinlimin"))) then
		do_tuna(crest_ok,crest_fail)
		return true
	else
		return false
	end
end
do_rest=function(rest_ok,rest_fail,l)
	rest["ok"]=rest_ok
	rest["fail"]=rest_fail
	meforce=me.skills.force
	if meforce==nil then
		meforce=0
	else
		meforce=meforce.lv
	end
	if ((lastsleep+sleepdelay)<os.time())or(meforce<75) then
		rest.sleep(l)
	else
		rest.dazuo()
	end
end

rest["end"]=function(s)
	EnableTriggerGroup("rest",false)
	if ((s~="")and(s~=nil)) then
		call(rest[s])
	end
	rest["ok"]=nil
	rest.fail=nil

end
rest_end_fail=function()
	rest["end"]("fail")
end
rest_end_ok=function()
	rest["end"]("ok")
end

rest["sleep"]=function(l)
	if l==nil then l=2500 end
	go(l,rest["sleeparrive"],rest_end_fail)
end
rest["sleeparrive"]=function()
	busytest(rest.sleepcmd)
end

rest["sleepcmd"]=function()
	EnableTrigger("rest_sleepok",true)
	run("sleep;set no_more sleepok")
end
rest_sleepok=function()
	lastsleep=os.time()
	busytest(rest_end_ok)
end


rest["dazuo"]=function()
	go(-2,rest["dazuoarrive"],rest_end_fail)
end



dazuo=function(func)
	dazuonum=math.floor(getnum(me.hp.qixue)*0.8)
	if dazuonum<70 then dazuonum=70 end
	if dazuonum>500 then dazuonum=500 end
	run("dazuo "..tostring(dazuonum))
	busytest(func)
end

rest["dazuoarrive"]=function()
	busytest(rest["dazuocmd"])
end
rest["dazuocmd"]=function()
	dazuo(rest_end_ok)
end


tuna={}
tuna["ok"]=nil
tuna["fail"]=nil

do_tuna=function(tuna_ok,tuna_fail)
	tuna["ok"]=tuna_ok
	tuna["fail"]=tuna_fail
	go(-2,tuna.arrive,tuna_end_fail)
end

tuna.arrive=function()
	tuna.cmd()
	busytest(tuna_end_ok)
end
tuna.cmd=function(func)
	tunanum=math.floor(getnum(me.hp.jinqi)*0.8)
	if tunanum<70 then tunanum=70 end
	if tunanum>500 then tunanum=500 end
	run("tuna "..tostring(tunanum))
end
tuna["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(tuna[s])
	end
	tuna["ok"]=nil
	tuna["fail"]=nil
end

tuna_end_ok=function()
	tuna["end"]("ok")
end

tuna_end_fail=function()
	tuna["end"]("fail")
end

