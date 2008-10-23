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
masterquest.main=function()
	if masterquest.die==false then
		if masterquest.city=="��Զ" then
			busytest(mqfar.main)
		elseif masterquest.flee==true then
			do_mqask(masterquest.maincmd,masterquest.findfar)
		else
			do_mqkill(masterquest["city"],3,masterquest_end_ok,masterquest.asknpc)
		end
	else
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
	print("δ�õ�npc��Ϣ����ʼȫ��ͼͨ��")
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
	masterquest["end"]("ok")
end

masterquest_end_fail=function()
	masterquest["end"]("fail")
end

mqinfo=function(n,l,w)
	masterquest["npc"]=w[2]
	masterquest["city"]=string.sub(w[3],1,4)
end
setmqmastertri=function()
	SetTriggerOption ("mqinfo", "match", "^(> )*"..familys[me.fam].mastername.."�������������Ϳ�(.*)��˳�ۣ���˵�������(.*)����ȥ����������������ͷ�������")
	SetTriggerOption ("mqinfo1", "match", "^(> )*"..familys[me.fam].mastername.."���������(.*)(��������ҽ��ᣬ�޶�������˵�������|�����ν�����Ŵκ��������ԣ���˵�������)")
end
--------------------------------


mqfar["ok"]=nil
mqfar["fail"]=nil
mqfar.max=0
mqfar.index=1
do_mqfar=function(mqfar_ok,mqfar_fail)
	masterquest["city"]="��Զ"
	mqfar["ok"]=mqfar_ok
	mqfar["fail"]=mqfar_fail
	mqfar.max=#farlist
	if getnum(me.hp.exp)<400000 then
		mqfar.max=mqfar.max-4
	elseif getnum(me.hp.exp)<700000 then
		mqfar.max=mqfar.max-3
	end
	mqfar.index=1
	mqfar.main()
end

mqfar.main=function()
	if mqfar.index>mqfar.max then
		busytest(mqfar_end_fail)
	else
		print("ȫͼͨ��----"..farlist[mqfar.index])
		do_mqkill(farlist[mqfar.index],1,mqfar.ok,mqfar.searchend)
	end
end
mqfar.searchend=function()
	print(farlist[mqfar.index].."������ϣ�ȥ��һ������")
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
	SetTriggerOption ("mq_asknpc", "match", "^(> )*"..str.."˵����.*(��������˵������|��������|��˵�Ƕ㵽|����ȥ��|�Ѿ��㵽|������ȥ��|����Ҳ����˵����|����˵��|��������˵��|��˵����|������˵��������|����Ӧ����ȥ��)(.*)")
end
mq_asknpc=function(n,l,w)
	mqask.info=string.sub(w[3],1,4)
end
mq_asktest=function(n,l,w)
	if mqask.info~="" then
		masterquest["city"]=mqask.info
		masterquest.flee=false
		if masterquest["city"]~="��Զ" then
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
	npc.name=masterquest.npc
	setmqkilltri()
	mqkill.main()
end

mqkill["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqkill[s])
	end
	EnableTriggerGroup("masterquestkill",false)
	mqkill["ok"]=nil
	mqkill["fail"]=nil
end

mqkill_end_ok=function()
	mqkill["end"]("ok")
end

mqkill_end_fail=function()
	print("���˽ƻ��ƻ��Σ�û�ҵ�")
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
	EnableTriggerGroup("masterquestkill",true)
	do_kill(npc.id,mqkill_end_ok,mqkill.search)
end

mqkill.testyou=function()
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
	SetTriggerOption ("masterquest_npcfaint", "match", "^(> )*"..masterquest["npc"].."����һ�����ȣ����ڵ���һ��Ҳ�����ˡ�")
	SetTriggerOption ("masterquest_npcdie", "match", "^(> )*"..masterquest["npc"].."���ڵ��������˼��£���һ�죬�������������Ѫ�����ˣ�")
end
-------------------------------------