lastsleep=0
sleepdelay=100


rest={}
checkrest=function(crest_ok,crest_fail)
	neilimin=GetVariable("neilimin")
	if neilimin=="" or neilimin ==nil then
		neilimin=0
	else
		neilimin=tonumber(neilimin)
	end
	print (me.hp.neili)
	if me.hp.neili< neilimin then
		do_rest(crest_ok,crest_fail)
		return true
	else
		return false
	end
end
do_rest=function(rest_ok,rest_fail)
	rest["ok"]=rest_ok
	rest["fail"]=rest_fail
	if ((lastsleep+sleepdelay)<os.time())or(mejifaforcelv()<100) then
		rest.sleep()
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

rest["sleep"]=function()
	go(2500,rest["sleeparrive"],rest_end_fail)
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