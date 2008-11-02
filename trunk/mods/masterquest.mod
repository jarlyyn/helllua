masterquest={}
mqfar={}
mqkill={}
masterquest["ok"]=nil
masterquest["fail"]=nil

initmq=function()
	masterquest["npc"]=""
	masterquest["npcid"]=""
	masterquest["city"]=""
	masterquest.flee=false
	masterquest.die=false
	mqfar.index=1
	mqfar.max=0
	npc.id=nil
	mqkill["searchcount"]=0
	mqkill["city"]=""
	mqkill["searchmax"]=1
end
initmq()
do_masterquest=function(masterquest_ok,masterquest_fail)
	masterquest["ok"]=masterquest_ok
	masterquest["fail"]=masterquest_fail
	setmqmastertri()
	initmq()
	masterquest.main()
end
masterquest.loop=function()
	busytest(masterquest.loopcmd)
end
masterquest.loopcmd=function()
	do_masterquest(masterquest.loop,masterquest.loop)
end

masterquest.main=function()
	getstatus(masterquest["check"])
end

masterquest.check=function()
	if do_check(masterquest["main"],masterquest["main"]) then
	elseif checkstudy(masterquest["main"],masterquest["main"]) then
	elseif checkfangqi(masterquest["main"],masterquest["main"]) then
	elseif checkjiqu(masterquest["main"],masterquest["main"]) then
	elseif quest.stop and masterquest.die==true then
		masterquest["end"]()
		return
	else
		busytest(masterquest.case)
	end
end

masterquest.go=function(mqnpc,mqcity,mqflee)
	initmq()
	masterquest["npc"]=mqnpc
	masterquest["city"]=mqcity
	if mqflee==true then
		masterquest["flee"]=true
	end
	busytest(masterquest.main)
end
mq=masterquest.go

masterquest.askquest=function()
	go(familys[me.fam].masterloc,masterquest.arrive,masterquest_end_fail)
end
masterquest.arrive=function()
	busytest(masterquest.questgive)
end
masterquest.questgive=function()
	initmq()
	run("give head to "..familys[me.fam].masterid..";drop head;quest cancel")
	busytest(masterquest.questcmd)
end

masterquest.questcmd=function()
	trigrpon("mqinfo")
	npchere(familys[me.fam].masterid,"quest "..familys[me.fam].masterid)
	trigrpoff("mqinfo")
	infoend(masterquest.questok)
end
masterquest.questok=function()
	if masterquest.npc~="" and  masterquest.npc~=nil then
		busytest(masterquest.main)
	else
		masterquest_end_fail()
	end
end
masterquest.case=function()
	if masterquest.die==false and masterquest.npc~="" then
		if masterquest.city=="很远" then
			busytest(mqfar.main)
		elseif masterquest.flee==true then
			do_mqask(masterquest.maincmd,masterquest.findfar)
		else
			do_mqkill(masterquest["city"],3,masterquest_end_ok,masterquest.asknpc)
		end
	else
		masterquest.askquest()
	end
end
masterquest.maincmd=function()
	busytest(masterquest.main)
end

masterquest.asknpc=function()
	do_mqask(masterquest.maincmd,masterquest.findfar)
end
masterquest.killnpc=function()
	do_mqkill(masterquest["city"],3,masterquest_end_ok,masterquest.asknpc)
end
masterquest.findfar=function()
	print("未得到npc信息，开始全地图通缉")
	do_mqfar(masterquest.main,masterquest.main)
end
masterquest["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(masterquest[s])
	end
	EnableTriggerGroup("masterquestkill",false)
	masterquest["ok"]=nil
	masterquest["fail"]=nil
end



masterquest_end_ok=function()
	if quest.stop and masterquest.die==true then
		masterquest["end"]()
	else
		masterquest["end"]("ok")
	end
end

masterquest_end_fail=function()
	masterquest["end"]("fail")
end

mqinfo=function(n,l,w)
	masterquest["npc"]=w[2]
	masterquest["city"]=string.sub(w[4],1,4)
end
masterflee=function()
	masterquest.flee=true
end
setmqmastertri=function()
	SetTriggerOption ("mqinfo", "match", "^(> )*"..familys[me.fam].mastername.."对你道：“我早就看(.*)不顺眼，听说(他|她)最近在(.*)，你去做了他，带他的人头来交差！”")
	SetTriggerOption ("mqinfo1", "match", "^(> )*"..familys[me.fam].mastername.."对你道：“(.*)(这个败类打家劫舍，无恶不作，听说他最近在|这个所谓大侠屡次和我派作对，听说他最近在)(.*)")
	SetTriggerOption ("masterflee", "match", "^(> )*"..familys[me.fam].mastername.."话音刚落，突然一人急急忙忙的赶了过来")
end
masterquest.givehead=function()
	go(familys[me.fam].masterloc,masterquest.giveheadcmd,masterquest_end_fail)
end
masterquest.giveheadcmd=function()
	run("give head to "..familys[me.fam].masterid..";drop head;quest cancel")
	busytest(masterquest.main)
end
--------------------------------


mqfar["ok"]=nil
mqfar["fail"]=nil
mqfar.max=0
mqfar.index=1
do_mqfar=function(mqfar_ok,mqfar_fail)
	masterquest["city"]="很远"
	mqfar["ok"]=mqfar_ok
	mqfar["fail"]=mqfar_fail
	mqfar.max=#farlist
	if getnum(me.hp.exp)<400000 then
		mqfar.max=mqfar.max-3
	elseif getnum(me.hp.exp)<700000 then
		mqfar.max=mqfar.max-2
	end
	mqfar.index=1
	mqfar.main()
end

mqfar.main=function()
	if mqfar.index>mqfar.max then
		initmq()
		busytest(mqfar_end_fail)
	else
		print("全图通缉----"..farlist[mqfar.index])
		do_mqkill(farlist[mqfar.index],3,mqfar.ok,mqfar.searchend)
	end
end
mqfar.searchend=function()
	print(farlist[mqfar.index].."搜索完毕，去下一个城市")
	mqfar.index=mqfar.index+1
	busytest(mqfar.main)
end
mqfar["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqfar[s])
	end
	mqfar["ok"]=nil
	mqfar["fail"]=nil
end

mqfar_end_ok=function()
	mqfar["end"]("ok")
end

mqfar_end_fail=function()
	mqfar["end"]("fail")
end


------------------------------------

mqask={}
mqask["ok"]=nil
mqask["fail"]=nil

do_mqask=function(mqask_ok,mqask_fail)
	mqask["ok"]=mqask_ok
	mqask["fail"]=mqask_fail
	mqask.info=""
	do_askinfolist(masterquest["npc"],city[masterquest["city"]].info,mqask.settri,mq_asktest,mqask_end_ok,mqask_end_fail)
end
mqask.settri=function(str)
	SetTriggerOption ("mq_asknpc", "match", "^(> )*"..str.."说道：.*(好像听人说过是在|他不是在|据说是躲到|好像去了|已经躲到|好像是去了|但是也有人说他在|有人说在|不过听人说在|听说是在|不过听说他好像在|现在应该是去了)(.*)")
end
mq_asknpc=function(n,l,w)
	mqask.info=string.sub(w[3],1,4)
end
mq_asktest=function(n,l,w)
	if mqask.info~="" then
		masterquest.flee=false
		masterquest["city"]=mqask.info
		masterquest.flee=false
		if masterquest["city"]~="很远" then
			askinfolist_end_ok()
		else
			askinfolist["end"]()
			mqask["end"]()
			busytest(masterquest.findfar)
		end
	else
		askinfolist.askcmd()
	end

end
mqask["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqask[s])
	end
	mqask["ok"]=nil
	mqask["fail"]=nil
end

mqask_end_ok=function()
	mqask["end"]("ok")
end

mqask_end_fail=function()
	mqask["end"]("fail")
end


----------------------------------


mqkill["ok"]=nil
mqkill["fail"]=nil

do_mqkill=function(mqkcity,mqkmax,mqkill_ok,mqkill_fail)
	mqkill["ok"]=mqkill_ok
	mqkill["fail"]=mqkill_fail
	mqkill["city"]=mqkcity
	mqkill["searchmax"]=mqkmax
	mqkill["searchcount"]=1
--	hook(hooks.killme,mqkill.onkillme)
	npc.name=masterquest.npc
	setmqkilltri()
	mqkill.main()
end

mqkill["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqkill[s])
	end
	hook(hooks.killme,nil)
	EnableTriggerGroup("masterquestkill",false)
	mqkill["ok"]=nil
	mqkill["fail"]=nil
end

mqkill_end_ok=function()
	mqkill["end"]("ok")
end

mqkill_end_fail=function()
	print("敌人狡猾狡猾滴，没找到")
	mqkill["end"]("fail")
end
mqkill.main=function()
	if mqkill["searchmax"]<mqkill["searchcount"] then
		mqkill_end_fail()
	else
		mqkill["searchcount"]=mqkill["searchcount"]+1
		fightpreper()
		eatdrink()
		busytest(mqkill.search)
	end
end
mqkill.search=function()
		do_npcinpath(city[mqkill["city"]].path,mqkill.npcfind,mqkill.main)
end

mqkill.npcfind=function()
	mqkill["searchcount"]=1
	masterquest.city=mqkill["city"]
	EnableTriggerGroup("masterquestkill",true)
	do_kill(npc.id,mqkill.heal,mqkill.search)
end

mqkill.heal=function()
	hp()
	busytest(mqkill.healcmd)
end
mqkill.healcmd=function()
	if checkdispel(mqkill.heal,mqkill.heal) then
	elseif masterquest.flee==true and (me.hp["qixue%"]<getvbquemin()) then
		do_heal(mqkill.heal,mqkill.heal,true) 
	else
		busytest(mqkill.killend)
	end
end
mqkill.killend=function()
	if masterquest.die==true then
		masterquest.givehead()
	else
		masterquest.flee=true
		mqkill["end"]()
		masterquest.main()
	end
end

mqkill.testyou=function()
	
end
	killmeloc=0
mqkill.onkillme=function(npcname)
	killmeloc=_roomid
	if npcname==masterquest.npc then
		infoend(mqkill.npckillme)
	end
end
mqkill.npckillme=function()
	if _roomid~=killmeloc then
		go(npc.loc,mqkill.npcfind,mqkill.main)	
	else
		mq.npcfind()
	end
	steppath["end"]()
	npcinpath["end"]()
end

masterquest_npcfaint=function()
	masterquest.die=true
	run("get silver from "..npc.id)
end
masterquest_npcdie=function()
	masterquest.die=true
	run("cut head from corpse;get head")
end
setmqkilltri=function()
	SetTriggerOption ("masterquest_npcfaint", "match", "^(> )*"..masterquest["npc"].."脚下一个不稳，跌在地上一动也不动了。")
	SetTriggerOption ("masterquest_npcdie", "match", "^(> )*"..masterquest["npc"].."扑在地上挣扎了几下，腿一伸，口中喷出几口鲜血，死了！")
end

-------------------------------------