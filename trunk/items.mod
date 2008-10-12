dofile("items.ini")
itemlist={}
on_itemsstart=function(name, line, wildcards)
	titemlist={}
	EnableTrigger("on_items",true)
end
on_itemsend=function(name, line, wildcards)
	itemlist=titemlist
	EnableTrigger("on_items",false)
end
on_items=function(name, line, wildcards)
	_item,num=getitemnum(wildcards[2])
	titemlist[_item]=num
	titemlist[wildcards[3]]=num
end
on_itemsground=function(name, line, wildcards)
end

item={}
item["item"]=""
item["go"]=function(itemname,itemnum,item_ok,item_fail)
	item["ok"]=item_ok
	item["fail"]=item_fail
	item["item"]=itemname
	item["num"]=itemnum
	if items[item["item"]]==nil then
		item["end"]("fail")
		return
	end
	do_walk(items[item["item"]]["loc"],item["get"],item["end"]("fail"))
end
item["end"]=function(s)
	if ((s~="")and(s~=nil)) then 
		callhook(item[s]) 
	end
	item["ok"]=nil
	item["fail"]=nil
end

item["get"]=function()
	if itemlist[item["item"]]==nil then
		num=0
	else
		num=itemlist[item["item"]]
	end
	if item["num"]>num then
		busytest(item[items[item["item"]]["type"]])
	else
		item["end"]("ok")
	end
end

item["buy"]=function()
	num=getnum(items[item["item"]]["buymax"])
	if (num <2) then
		run("buy "..items[item["item"]]["id"].." from "..items[item["item"]]["npc"]..";i")
	else
		num2=item["num"]-itemsnum(item["item"])
		if num>num2 then num=num2 end
		run("buy "..tostring(num).." "..items[item["item"]]["id"].." from "..items[item["item"]]["npc"]..";i")
	end
	busytest(item["get"])
end
itemsnum=function(name)
	return(getnum(itemlist[name]))
end

checkitems=function(_items,check_ok,check_fail)
	for i,v in pairs(_items) do
		if itemsnum(i)<v["min"] then
			print(items[i]["id"])
			item["go"](items[i]["name"],v["max"],check_ok,check_fail)
			return true
		end
	end
	return false
end