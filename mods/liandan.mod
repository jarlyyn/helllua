liandan={}
liandan["ok"]=nil
liandan["fail"]=nil
liandan.items={}
liandan.items["����"]={min=1,max=1}
liandan.sells={}
liandan.sells["���赤"]={name="���赤",id="huoqi dan"}
liandan.sells["��Ԫ��"]={name="��Ԫ��",id="guiyuan dan"}
liandan.sells["С����"]={name="С����",id="xiaohuan dan"}
liandan.sells["�󻹵�"]={name="�󻹵�",id="dahuan dan"}
liandan.sells["�󲹵�"]={name="�󲹵�",id="dabu dan"}
liandan.sells["ѩ�ε�"]={name="ѩ�ε�",id="xueshen dan"}
liandan.sells["ʮȫ�󻹵�"]={name="ʮȫ�󻹵�",id="shiquan dan"}
liandan.sells["���Ƶ�"]={name="���Ƶ�",id="dayun dan"}
liandan.sells["������"]={name="������",id="yangjing dan"}
liandan.sells["��Ȫ��"]={name="��Ȫ��",id="suoquan dan"}
liandan.sells["С��"]={name="С��",id="gold dan"}
liandan.sells["С�Ƶ�"]={name="С�Ƶ�",id="xiaoyun dan"}
liandan.sells["���"]={name="���",id="xujing dan"}
liandan.sells["��Ȫ��"]={name="��Ȫ��",id="biquan dan"}
liandan.sells["���鵤"]={name="���鵤",id="huanling dan"}
liandan.pack={}
liandan.pack["Guiling dan"]="guiling dan"
liandan.pack["Ѫ�赤"]="xueqi dan"
liandan.pack["ӳ�µ�"]="yingyue dan"
liandan.pack["�����޳���"]="xiuluo dan"
liandan.pack["�����޼���"]="huiyang dan"
liandan.pack["������"]="bujing dan"
liandan.pack["���굤"]="huanhun dan"
liandan.pack["���ѵ�"]="longxian dan"
liandan.pack["���µ�"]="yaoyue dan"
liandan.pack["�������׵�"]="longjia dan"
liandan.dropgift={}
liandan.dropgift["Luosha dan"]="luosha dan"
liandan.dropgift["��ԯ���ĵ�"]="xuanyuan dan"
liandan.eat={}
liandan.eat["Wanshou dan"]="wanshou dan"
liandan.eat["Zhuque dan"]="zhuque dan"
liandan.eat["Baihu dan"]="baihu dan"
liandan.eat["Qinglong dan"]="qinglong dan"
liandan.eat["Xuanwu dan"]="xuanwu dan"
liandan.eat["Yinyang dan"]="yinyang dan"
liandan.eat["Longwang dan"]="longwang dan"
liandan.yaoanswer=0
liandan.tonganswer=0
liandan.loc={1397,1398,1399,1400,1401}
liandan.recon=function()
end
do_liandan=function(liandan_ok,liandan_fail)
	liandan["ok"]=liandan_ok
	liandan["fail"]=liandan_fail
	EnableTriggerGroup("liandan",true)
	busytest(liandan.main)
end
liandan.loop=function()
	busytest(liandan.loopcmd)
end
liandan.loopcmd=function()
	do_liandan(liandan.loop,liandan.loop)
end
liandan.main=function()
	if quest.stop then
		liandan["end"]()
		return
	end
	getstatus(liandan["check"])
end

liandan.check=function()
	if do_check(liandan["main"]) then
	elseif checkitems(liandan.items,liandan["main"],liandan["main"]) then
	elseif checkgiftdrop(liandan.dropgift,liandan["main"],liandan.packluosha) then
	elseif checksell(liandan.sells,liandan["main"],liandan["main"],1291) then
	elseif checkpack(liandan.pack,"baoguo",liandan["main"],liandan["main"],1291) then
	elseif check_eatdan(liandan.eat,liandan["main"]) then
	elseif checkstudy(liandan["main"]) then
	elseif checkfangqi(liandan["main"],liandan["main"]) then
	elseif itemsnum("cao yao")>0 then
		busytest(liandan.caiyaogive)
	else
		busytest(liandan.askyao)
	end
end
liandan.packluosha=function()
	do_pack("dan","baoguo",liandan["main"],liandan["main"])
end
liandan.askyao=function()
	go(1388,liandan.askyaocmd,liandan_end_fail)
end

liandan.askyaocmd=function()
	liandan.yaoanswer=0
	npchere("yao chun","yun regenerate;ask yao chun about liandan")
	infoend(liandan.askyaook)
end
liandan_yaook=function()
	liandan.yaoanswer=1
end

liandan.askyaook=function()
	if npc.nobody>0 then
		liandan_end_fail()
	elseif 	liandan.yaoanswer==1 then
		busytest(liandan.askyaocmd)
	else
		busytest(liandan.asktong)
	end
end

liandan.asktong=function()
	go(1387,liandan.asktongcmd,liandan_end_fail)
end
liandan.asktongcmd=function()
	liandan.tonganswer=0
	npchere("xiao tong","yun regenerate;ask xiao tong about ҩ��")
	infoend(liandan.asktongok)
end

liandan.asktongok=function()
	if npc.nobody>0 then
		liandan_end_fail()
	elseif 	liandan.tonganswer==1 then
		busytest(liandan.caiyao)
	elseif 	liandan.tonganswer==2 then
		busytest(liandan.liandan)
	else
		busytest(liandan.askyao)
	end
end

liandan_tongcai=function()
	liandan.tonganswer=1
end

liandan_tonglian=function()
	liandan.tonganswer=2
end

liandan.caiyao=function()
	if GetVariable("pfm")~=nil and GetVariable("pfm")~="" then
		hook(hooks.fight,pfm)
	end
	local loc=liandan.loc[math.random(1,#liandan.loc)]
	weapon(1)
	go(loc,liandan.caiyaocmd,liandan_end_fail)
end

liandan.caiyaocmd=function()
	run("cai yao")
	if hashook(hooks.fight) then run("kill du langzhong;kill du she") end
	busytest(liandan.caiyaook)
end

liandan.caiyaook=function()
	run("i")
	infoend(liandan.caiyaotest)
end
liandan.caiyaotest=function()
	if itemsnum("cao yao")>0 then
		busytest(liandan.caiyaogive)
	else
		busytest(liandan.caiyaocmd)
	end
end
liandan.caiyaogive=function()
	go(1387,liandan.caiyaogivecmd,liandan_end_fail)
end

liandan.caiyaogivecmd=function()
	run("give cao yao to xiao tong")
	busytest(liandan.liandan)
end
liandan.liandan=function()
	go(1389,liandan.liandancmd,liandan_end_fail)
end

liandan.liandancmd=function()
	run("liandan")
	busytest(liandan_end_ok)
end

liandan["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(liandan[s])
	end
	hook(hooks.fight,nil)
	EnableTriggerGroup("liandan",false)
	liandan["ok"]=nil
	liandan["fail"]=nil
end

liandan_end_ok=function()
	liandan["end"]("ok")
end

liandan_end_fail=function()
	liandan["end"]("fail")
end

check_eatdan=function(eatdan_list,eatdan_ok,eatdan_fail)
	for i,v in pairs(eatdan_list) do
		if itemsnum(i)>0 then
			run("eat "..v)
			busytest(eatdan_ok)
			return true
		end
	end
	return false
end
