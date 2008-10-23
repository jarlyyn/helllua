info={}
info.fail=2
info.retry=1
info.answer=3
askinfo=function(npc,content)
	info.answer=3
	if infolist[npc]~=nil then
		setinfoname(infolist[npc]["name"])
		trigrpon("info")
		npchere(infolist[npc]["id"],"yun regenerate;ask "..infolist[npc]["id"].." about "..content)
		trigrpoff("info")
	end
end

setinfoname=function(str)
	SetTriggerOption ("info_fail", "match", "^(> )*("..str..")(ҡҡͷ��˵����û��˵����|�ɻ�ؿ����㣬ҡ��ҡͷ��|�����۾������㣬��Ȼ��֪������˵ʲô��|�����ʼ磬�ܱ�Ǹ��˵���޿ɷ�档|˵������....���ҿɲ��������������ʱ��˰ɡ�|����һ�����˵�����Բ������ʵ�����ʵ��û��ӡ��)")
	SetTriggerOption ("info_retry", "match", "^(> )*("..str..")˵����(���磡�е��ð��������˼��|��...�ȵȣ���˵ʲô��û�������|�ţ��ԵȰ����ͺ�... ���ˣ���ղ�˵ɶ��|���... ���... Ŷ�����ˣ������������أ�|���ϣ�... ������˼����������ô��|�ͺ�... �ͺ�... ���ˣ���˵ɶ��|���ɶ��û����æ����ô��|!)")
end

info_fail=function()
	info.answer=info.fail
end

info_retry=function()
	info.answer=info.retry
end

-------------------------------

askinfolist={}
askinfolist["ok"]=nil
askinfolist["fail"]=nil
askinfolist["content"]=""
askinfolist["list"]={}
askinfolist.hook=nil
askinfolist.ailsettri=nil
askinfolist["index"]=0
ailre=rex.new("([0-9]+)")
do_askinfolist=function(content,aillist,ailsettri,ailtest,askinfolist_ok,askinfolist_fail)
	askinfolist["ok"]=askinfolist_ok
	askinfolist["fail"]=askinfolist_fail
	askinfolist["content"]=content
	askinfolist["list"]={}
	askinfolist["index"]=0
	askinfolist.hook=ailtest
	askinfolist.ailsettri=ailsettri
	local i=0
	n=ailre:gmatch(aillist,function (m, t)
		i=i+1
		askinfolist["list"][i]=m
	end)
	busytest(askinfolist.main)	
end

askinfolist.main=function()
	askinfolist["index"]=askinfolist["index"]+1
	if #askinfolist["list"]<askinfolist["index"] then
		busytest(askinfolist_end_fail)
	else
		if infolist[askinfolist["list"][askinfolist["index"]]]~=nil then
			go(infolist[askinfolist["list"][askinfolist["index"]]].loc,askinfolist.arrive,askinfolist.main)
		else
			askinfolist.main()
		end
	end
end

askinfolist.arrive=function()
	busytest(askinfolist.askcmd)
end

askinfolist.askcmd=function()
	print("ѯ��"..askinfolist["list"][askinfolist["index"]].."���Ե�")
	if askinfolist.ailsettri~=nil then
		askinfolist.ailsettri(infolist[askinfolist["list"][askinfolist["index"]]].name)
	end	
	askinfo(askinfolist["list"][askinfolist["index"]],askinfolist["content"])
	infoend(askinfolist.asktest)
end

askinfolist.asktest=function()
	if npc.nobody==1 or info.answer==2 then
		 askinfolist.main()
	elseif info.answer==1 then 
		askinfolist.arrive()
	else
		call(askinfolist.hook)
	end
end

askinfolist["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(askinfolist[s])
	end
	askinfolist["ok"]=nil
	askinfolist["fail"]=nil
	askinfolist.alisettri=nil
	askinfolist.hook=nil
end

askinfolist_end_ok=function()
	askinfolist["end"]("ok")
end

askinfolist_end_fail=function()
	askinfolist["end"]("fail")
end



