test=[[
mapping rcv_npcs = ([
        "/d/city3/bingqidian"     : "tang huai",
        "/d/city3/wuguan"         : "ma wude",
        "/d/dali/bingying"        : "wei shi",
        "/d/dali/tusifu"          : "da tusi",
        "/d/changan/xunbufang"    : "bu tou",
        "/d/changan/biaoju-damen" : "biaoshi",
        "/d/changan/qunyulou"     : "da shou",
        "/d/city/wuguan"          : "chen youde",
        "/d/city/dongmen"         : "wu jiang",
        "/d/beijing/xichang"      : "tai jian",
        "/d/beijing/xichengmen"   : "du cha",
        "/d/shaolin/ruzhou"       : "wu jiang",
        "/d/shaolin/shanmen"      : "xu ming",
        "/d/suzhou/bingying"      : "wu jiang",
        "/d/suzhou/toumenshan"    : "jian ke",
        "/d/hangzhou/liuzhuang"   : "guan jia",
        "/d/hangzhou/yuhuangsd"   : "yu yutong",
        "/d/fuzhou/biaoju"        : "bai er",
        "/d/quanzhou/jiaxinggang" : "lao chuanfu",
        "/d/lingzhou/xiaoxiaochang" : "xixia bing",
        "/d/lingzhou/jiangjungate"  : "xiao wei",
]);
]]


beiqiinfo={}
beiqiinfo["list"]={"yzcyd","yzwj","hzyyt","hzgj","bjtj","bjdc","rzwj","cdmwd","cdth","dlts","dlws","cabt","cabs","cads","szwj","szjk","fzbe","lzxxb","lzxw"}
beiqiinfo["yzcyd"]={info="01",npc="陈有德",npcid="chen youde"}
beiqiinfo["yzcyd"]["扬州武馆"]=8
beiqiinfo["yzwj"]={info="01",npc="武将",npcid="wu jiang"}
beiqiinfo["yzwj"]["东门"]=67
beiqiinfo["yzwj"]["南门"]=54
beiqiinfo["yzwj"]["西门"]=13
beiqiinfo["yzwj"]["北门"]=34
beiqiinfo["hzyyt"]={info="08",npc="余鱼同",npcid="chen youde"}
beiqiinfo["hzyyt"]["玉皇山顶"]=831
beiqiinfo["hzgj"]={info="08",npc="管家",npcid="guan jia"}
beiqiinfo["hzgj"]["刘庄"]=874
beiqiinfo["bjtj"]={info="51",npc="太监",npcid="tai jian"}
beiqiinfo["bjtj"]["西厂"]=1381
beiqiinfo["bjdc"]={info="51",npc="城门督察",npcid="du cha"}
beiqiinfo["bjdc"]["西城门"]=1356
beiqiinfo["rzwj"]={info="29",npc="武将",npcid="wu jiang"}
beiqiinfo["rzwj"]["汝州城"]=1356
beiqiinfo["cdmwd"]={info="39",npc="马武德",npcid="ma wude"}
beiqiinfo["cdmwd"]["金牛武馆"]=690
beiqiinfo["cdth"]={info="39",npc="唐槐",npcid="ma wude"}
beiqiinfo["cdth"]["兵器铺"]=682
beiqiinfo["dlts"]={info="32",npc="大土司",npcid="da tusi"}
beiqiinfo["dlts"]["土司府"]=452
beiqiinfo["dlws"]={info="32",npc="黄衣卫士",npcid="wei shi"}
beiqiinfo["dlws"]["兵营"]=456
beiqiinfo["cabt"]={info="12",npc="捕头",npcid="bu tou"}
beiqiinfo["cabt"]["巡捕房"]=381
beiqiinfo["cabs"]={info="12",npc="钱镖师",npcid="biaoshi"}
beiqiinfo["cabs"]["河洛镖局"]=334
beiqiinfo["cads"]={info="12",npc="打手",npcid="da shou"}
beiqiinfo["cads"]["群玉楼"]=331
beiqiinfo["szwj"]={info="05",npc="武将",npcid="wu jiang"}
beiqiinfo["szwj"]["兵营"]=950
beiqiinfo["szjk"]={info="05",npc="剑客",npcid="jian ke"}
beiqiinfo["szjk"]["头门山"]=935
beiqiinfo["fzbe"]={info="24",npc="白二",npcid="bai er"}
beiqiinfo["fzbe"]["福威镖局"]=224
beiqiinfo["lzxxb"]={info="37",npc="西夏兵",npcid="xixia bing"}
beiqiinfo["lzxxb"]["小校场"]=1199
beiqiinfo["lzxw"]={info="37",npc="校尉",npcid="xiao wei"}
beiqiinfo["lzxw"]["大将军府"]=1187

beiqi={}
beiqi["ok"]=nil
beiqi["fail"]=nil
beiqi["info"]={}
beiqi["npc"]=""
beiqi["loc"]=""
beiqi["item"]=""
do_beiqi=function(beiqi_ok,beiqi_fail)
	beiqi["ok"]=beiqi_ok
	beiqi["fail"]=beiqi_fail
	beiqi["info"]=beiqiinfo[beiqiinfo["list"][math.random(1,#beiqiinfo["list"])]]
	go(infolist[beiqi.info.info].loc,beiqi.arrive,beiqi_end_fail)
end

beiqi["end"]=function(s)
	EnableTrigger("beiqi_infook",false)
	if ((s~="")and(s~=nil)) then
		call(beiqi[s])
	end
	beiqi["ok"]=nil
	beiqi["fail"]=nil
end

beiqi_end_ok=function()
	beiqi["end"]("ok")
end

beiqi_end_fail=function()
	beiqi["end"]("fail")
end

beiqi["arrive"]=function()
	busytest(beiqi["ask"])	
end

beiqi["ask"]=function()
	setbeiqiname()
	EnableTrigger("beiqi_infook",true)
	beiqi["item"]=""
	print("test1")
	askinfo(beiqi.info.info,beiqi.info.npc.."的事")
	print("test2")
	infoend(beiqi["askend"])	
end

beiqi["askend"]=function()
	EnableTrigger("beiqi_infook",false)
	if beiqi.item~="" then
		item["go"](beiqi.item,1,beiqi["buyok"],beiqi_end_fail)
		return
	end
	if info.answer==info.retry then
		busytest(beiqi.ask)
		return
	elseif info.answer==info.fail or info.answer==3 then
		busytest(beiqi_end_fail)
		return
	end
end

beiqi_infook=function(n,l,w)
	if items[w[3]]~=nil then
		if items[w[3]].type=="buy" and beiqi["info"][w[2]]~=nil then
			beiqi["item"]=w[3]
			beiqi["loc"]=beiqi["info"][w[2]]
		end
	end
end

setbeiqiname=function()
	SetTriggerOption ("beiqi_infook", "match", "^(> )*"..infolist[beiqi.info.info].name.."说道：据说(.*)的"..beiqi.info.npc.."急需一批(.*)。嘿！你说他想干什么？$")
end

beiqi["buyok"]=function()
	go(beiqi["loc"],beiqi["give"],beiqi["give"])
end

beiqi["give"]=function()
	run("give "..items[beiqi["item"]].id.." to "..beiqi["info"]["npcid"])
	beiqi.giveend()
end

beiqi.giveend=function()
	busytest(beiqi_end_ok)	
end

beiqi["main"]=function()
	if quest.stop then
		beiqi["end"]()
		return
	end
	busytest(beiqi["checkcmd"])
end

beiqi["checkcmd"]=function()
	getstatus(beiqi["check"])
end
beiqi.check=function()
	if do_check(beiqi["main"]) then
	elseif checkstudy(beiqi["main"]) then
	else
		do_beiqi(beiqi["main"],beiqi["main"])
	end
end

