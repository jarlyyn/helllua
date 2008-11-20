loadmod("bank.mod")
check={}
do_check=function(checkcallback)
	check["callback"]=checkcallback
	if checkdispel(checkcallback,checkcallback) then
	elseif itemsnum("Gold")>(tonumber(GetVariable("goldmin"))*3) then
		busytest(c_cungold)
	elseif itemsnum("Silver")>(silvermax) then
		busytest(c_duihuansilver)
	elseif itemsnum("Coin")>(coinmax) then
		busytest(c_duihuancoin)
	elseif itemsnum("Gold")<(tonumber(GetVariable("goldmin"))) then
		busytest(c_qugold)
	elseif GetVariable("pfm")=="shot" and itemsnum("������")<10 then
		item["go"]("������",30,checkcallback,checkcallback)
	elseif GetVariable("pfm")=="shot" and itemsnum("���������")==0 and itemsnum("����")==0 and itemsnum("�̹�")==0 then
		item["go"]("����",1,checkcallback,checkcallback)
	elseif checkrest(check["callback"],check["callback"]) then
	elseif checkheal(check["callback"],check["callback"]) then
	elseif checkitems(inv,check["callback"],check["callback"]) then
	elseif checkrepair(check["callback"],check["callback"]) then
	elseif checksell(invsells,check["callback"],check["callback"]) then
	elseif checkgiftdrop(gifttodrop,check["callback"],check["callback"]) then
	else
		return false
	end
	return true
end

c_cungold=function()
	do_bank("cun",(itemsnum("Gold")-GetVariable("goldmin")-1),"gold",check["callback"])
end
c_qugold=function()
	do_bank("qu",(GetVariable("goldmin")-itemsnum("Gold")+1),"gold",check["callback"])
end
c_duihuansilver=function()
	do_bank("duihuan",(math.floor(itemsnum("Silver")/100))*100,"silver",check["callback"])
end
c_duihuancoin=function()
	do_bank("duihuan",(math.floor(itemsnum("Coin")/100))*100,"coin",check["callback"])
end

checknuqi=function(nuqiok,nuqifial)
	if ((me.score.xingge=="�ĺ�����")or(me.score.xingge=="��������"))and(tonumber(GetVariable("neilimin"))>1000)and((me.hp.nuqi~="ŭ������")and(me.hp.nuqi~="�������")) then
		run("baofa")
		busytest(nuqiok)
		return true
	end
	return false
end
