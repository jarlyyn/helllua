itemlist={}
on_itemsstart=function(name, line, wildcards)
	mypass={}
	titemlist={}
	EnableTrigger("on_items",true)
end
on_itemsend=function(name, line, wildcards)
	itemlist=titemlist
	EnableTrigger("on_items",false)
end
mypass={}
on_items=function(name, line, wildcards)
	_item,num=getitemnum(wildcards[2])
	titemlist[_item]=num
	titemlist[wildcards[3]]=num
	if wildcards[3]=="pass" then
		if housepass[_item]~=nil then
			mypass[housepass[_item].name]=true
			print("找到:"..housepass[_item].name.."的pass")
		else
			print("没有找到--".._item.."对应的pass,请检查house.ini")
		end
	end
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
	go(items[item["item"]]["loc"],item["arrive"],itemendfail)
end

do_item=item["go"]

itemendfail=function()
	item["end"]("fail")
end
itemendok=function()
	item["end"]("ok")
end
item["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(item[s])
	end
	item["ok"]=nil
	item["fail"]=nil
end

item["arrive"]=function()
	if itemlist[item["item"]]==nil then
		num=0
	else
		num=itemlist[item["item"]]
	end
	if item["num"]>num then
		busytest(item[items[item["item"]]["type"]])
	else
		busytest(itemendok)
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
	busytest(item["arrive"])
end
item["cmd"]=function()
	run(items[item["item"]]["cmd"])
	run("i")
	busytest(item["arrive"])
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

loadmod("drop.mod")

tbaglist={}
_bagname=""
bags={}
bagscount={}
on_bagsstart=function(name, line, wildcards)
	_bagname=wildcards[2]
	tbaglist={}
	EnableTrigger("on_bagitems",true)
end
on_bagsend=function(name, line, wildcards)
	bags[_bagname]=tbaglist
	EnableTrigger("on_bagitems",false)
end
on_bagitems=function(name, line, wildcards)
	_item,num=getitemnum(wildcards[1])
	bagscount[_bagname]=bagscount[_bagname]+1
	tbaglist[_item]=num
	tbaglist[wildcards[2]]=num
end

getbagitems=function(bagname)
	bagscount[bagname]=0
	catch("bagitem","set no_more getbag-"..bagname..";l "..bagname..";set no_more getbagend")
end
