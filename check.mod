dofile("bank.mod")
dofile("config.ini")
_check=function()
	run("i;hp;score")
	busytest(_check)
end
check={}
do_check=function(checkcallback)
	check["callback"]=checkcallback
	if itemsnum("Gold")>(tonumber(GetVariable("goldmin"))*3) then
		busytest(c_cungold)
	elseif itemsnum("Silver")>(silvermax) then
		busytest(c_duihuansilver)
	elseif itemsnum("Coin")>(coinmax) then
		busytest(c_duihuancoin)
	elseif itemsnum("Gold")<(tonumber(GetVariable("goldmin"))) then
		busytest(c_qugold)
	elseif checkitems(inv,check["callback"]) then
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