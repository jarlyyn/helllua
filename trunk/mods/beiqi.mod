
beiqiinfo={}
beiqiinfo["list"]={"yzcyd","yzwj","hzyyt","hzgj","bjtj","bjdc","rzwj","cdmwd","cdth","dlts","dlws","cabt","cabs","cads","szwj","szjk","fzbe","lzxxb","lzxw"}
beiqiinfo["yzcyd"]={info="01",npc="���е�",npcid="chen youde"}
beiqiinfo["yzcyd"]["�������"]=8
beiqiinfo["yzwj"]={info="01",npc="�佫",npcid="wu jiang"}
beiqiinfo["yzwj"]["����"]=67
beiqiinfo["yzwj"]["����"]=54
beiqiinfo["yzwj"]["����"]=13
beiqiinfo["yzwj"]["����"]=34
beiqiinfo["hzyyt"]={info="08",npc="����ͬ",npcid="yu yutong"}
beiqiinfo["hzyyt"]["���ɽ��"]=831
beiqiinfo["hzgj"]={info="08",npc="�ܼ�",npcid="guan jia"}
beiqiinfo["hzgj"]["��ׯ"]=874
beiqiinfo["bjtj"]={info="51",npc="̫��",npcid="tai jian"}
beiqiinfo["bjtj"]["����"]=1381
beiqiinfo["bjdc"]={info="51",npc="���Ŷ���",npcid="du cha"}
beiqiinfo["bjdc"]["������"]=1356
beiqiinfo["rzwj"]={info="29",npc="�佫",npcid="wu jiang"}
beiqiinfo["rzwj"]["���ݳ�"]=1356
beiqiinfo["cdmwd"]={info="39",npc="�����",npcid="ma wude"}
beiqiinfo["cdmwd"]["��ţ���"]=690
beiqiinfo["cdth"]={info="39",npc="�ƻ�",npcid="tang huai"}
beiqiinfo["cdth"]["������"]=682
beiqiinfo["dlts"]={info="32",npc="����˾",npcid="da tusi"}
beiqiinfo["dlts"]["��˾��"]=452
beiqiinfo["dlws"]={info="32",npc="������ʿ",npcid="wei shi"}
beiqiinfo["dlws"]["��Ӫ"]=456
beiqiinfo["cabt"]={info="12",npc="��ͷ",npcid="bu tou"}
beiqiinfo["cabt"]["Ѳ����"]=381
beiqiinfo["cabs"]={info="12",npc="Ǯ��ʦ",npcid="biaoshi"}
beiqiinfo["cabs"]["�����ھ�"]=334
beiqiinfo["cads"]={info="12",npc="����",npcid="da shou"}
beiqiinfo["cads"]["Ⱥ��¥"]=331
beiqiinfo["szwj"]={info="05",npc="�佫",npcid="wu jiang"}
beiqiinfo["szwj"]["��Ӫ"]=950
beiqiinfo["szjk"]={info="05",npc="����",npcid="jian ke"}
beiqiinfo["szjk"]["ͷ��ɽ"]=935
beiqiinfo["fzbe"]={info="24",npc="�׶�",npcid="bai er"}
beiqiinfo["fzbe"]["�����ھ�"]=224
beiqiinfo["lzxxb"]={info="37",npc="���ı�",npcid="xixia bing"}
beiqiinfo["lzxxb"]["СУ��"]=1199
beiqiinfo["lzxw"]={info="37",npc="Уξ",npcid="xiao wei"}
beiqiinfo["lzxw"]["�󽫾���"]=1187

beiqisells={}
beiqisells["����"]={name="����",id="hammer"}
beiqisells["����"]={name="����",id="tiegun"}
beiqisells["����"]={name="����",id="armor"}
beiqisells["��ͨذ��"]={name="��ͨذ��",id="dagger"}
beiqisells["���"]={name="���",id="zhubang"}
beiqisells["��"]={name="��",id="zhujian"}
--beiqisells["�ɻ�ʯ"]={name="�ɻ�ʯ",id="feihuang shi",sellmax=100}
--beiqisells["������"]={name="������",id="tie lianzi",sellmax=100}
beiqisells["ľ��"]={name="ľ��",id="mu jian"}
beiqisells["ľ��"]={name="ľ��",id="mu dao"}
beiqisells["ľ��"]={name="ľ��",id="mu dao"}





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
	print("test")
	beiqi["item"]=""
	print("test2")
	askinfo(beiqi.info.info,beiqi.info.npc.."����")
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
	SetTriggerOption ("beiqi_infook", "match", "^(> )*"..infolist[beiqi.info.info].name.."˵������˵(.*)��"..beiqi.info.npc.."����һ��(.*)���٣���˵�����ʲô��$")
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
	elseif checksell(beiqisells,beiqi["main"],beiqi["main"]) then
	elseif checkstudy(beiqi["main"]) then
	else
		do_beiqi(beiqi["main"],beiqi["main"])
	end
end

