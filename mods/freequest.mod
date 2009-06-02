freequest={}
freequest["ok"]=nil
freequest["fail"]=nil

freequest.infolist={}
freequest.info=""
freequest.asktimes=4
freequest.askmax=4
freequest.askcount=0
freequest.questlist={}
freequest.questlistall={"feizei","fanzei","zhuisha","xunzhao"}
freequest.questlistnameall={feizei="����(����)",fanzei="����(а��)",zhuisha="׷ɱ",xunzhao="Ѱ��"}
do_freequest=function(freequest_ok,freequest_fail)
	freequest["ok"]=freequest_ok
	freequest["fail"]=freequest_fail
	EnableTriggerGroup("freequest",true)
	busytest(freequest.main)
end

freequest.resume=function()
	print(123)
	EnableTriggerGroup("freequest",true)
	busytest(freequest.main)
end

freequest.main=function()
	if quest.stop then
		freequest["end"]()
		return
	end
	getstatus(freequest["case"])
end

freequest.case=function()
	if do_check(freequest.main,freequest.main) then
	elseif checkstudy(freequest.main,freequest.main) then
	else
		busytest(freequest.goask)
	end
end

freequest["end"]=function(s)
	EnableTriggerGroup("freequest",false)
	if ((s~="")and(s~=nil)) then
		call(freequest[s])
	end
	freequest["ok"]=nil
	freequest["fail"]=nil
end

freequest_end_ok=function()
	freequest["end"]("ok")
end

freequest_end_fail=function()
	freequest["end"]("fail")
end

freequest.initinfo=function()
	local _info=math.random(1,infolistcount)
	if _info<10 then
		_info="0"..tostring(_info)
	else
		_info=tostring(_info)
	end
	freequest.info=_info
	return _info
end
freequest.goask=function()
	_info=freequest.initinfo()
	print(_info)
	freequest.settris(infolist[_info]["name"])
	freequest.askcount=1
	go(infolist[_info]["loc"],freequest.askrumor,freequest.main)
end

freequest.askrumor=function()
	if freequest.askmax<freequest.askcount then
		busytest(freequest.main)
	else
		freequest.askcount=freequest.askcount+1
		freequest.askrumorcmd()
	end
end
freequest.askrumorcmd=function()
	freequest.infolist={}
	askinfo(freequest.info,"rumor",freequest.asktimes)
	infoend(freequest.askrumorend)
end

freequest.settris=function(name)
--		addtri("freequest_on_shen","^(> )*"..name.."������(.*)��ɱ���㣡","shen","freequest_on_shen",flag_base_temp)
		print(addtri("freequest_oninfo","^(> )*"..name.."˵����(�������������������˵��|Ҳûʲô���£�ֻ����˵��|ǰ���컹���˼�˵��|�����������Щ����˵��|Ҳûʲô���£�ֻ����˵��|ǰ���컹���˼�˵|����������Ŀ���̸�����|�ޣ�¥��ס����Ǽ������˸ղ�˵ʲô��|ǰ������������������ʿ��һ�����Ǹ��֣����ǻ�˵�����|�������������йء�|�������ʢ����|��û��������Ҷ������ۡ�)(����(?P<fanzei>.*)|����(?P<feizei>.*)|׷ɱ(?P<zhuisha>.*)|Ѱ��(?P<xunzhao>.*)|)(���Ĵ��ţ�|����������أ�|����|���ء�|������|���ˡ�|����|�ء�|��������|���°��ˡ�|�����ء�)","freequest","freequest_oninfo",flag_base_temp))
end


freequest_oninfo=function(n,l,w)
	for i,v in pairs(freequest.questlist) do
		fqtritest(w,i)
	end
end

fqtritest=function(w,name)
	if w[name]~="" then freequest.infolist[name]=w[name] end
end

freequest.askrumorend=function(n,l,w)
	for i,v in pairs(freequest.infolist) do
		if fq[i]~=nil then
			print(i)
			fq[i]()
			return
		end
	end
	freequest.askrumor()
end
fq={}
-----------------------------------
fq["feizei"]=function()
	do_shen(freequest.infolist["feizei"],freequest.main,freequest.main)
end
fq["fanzei"]=function()
	do_shen(freequest.infolist["fanzei"],freequest.main,freequest.main)
end

shen={}
shen["ok"]=nil
shen["fail"]=nil
shen.name=""
shen.id=""
do_shen=function(name,shen_ok,shen_fail)
	shen.name=name
	shen.id=""
	shen.city=""
	shen["ok"]=shen_ok
	shen["fail"]=shen_fail
	shen.settris(name)
	EnableTriggerGroup("shen",true)
	shen.askcmd()
end

shen["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(shen[s])
	end
	EnableTriggerGroup("shen",false)
	shen["ok"]=nil
	shen["fail"]=nil
end

shen_end_ok=function()
	shen["end"]("ok")
end

shen_end_fail=function()
	shen["end"]("fail")
end

shen.askcmd=function()
	shen.city=""
	askinfo(freequest.info,shen.name,freequest.asktimes)
	infoend(shen.askcmdend)
end

shen.askcmdend=function()
	if npc.nobody==1 or info.answer==2 or shen.city=="" then
		 shen_end_ok()
	elseif info.answer==1 then
		shen.askcmd()
	else
		do_killnpcinpath(shen.name,city[shen.city].path,shen_end_ok,shen_end_ok)
	end
end


shen.settris=function(name)
		addtri("freequest_on_shen","^(> )*"..infolist[freequest.info]["name"].."˵����������˵����(.*)���������˺���ɶ��ˡ�","shen","freequest_on_shen",flag_base_temp)
end

freequest_on_shen=function(n,l,w)
	shen.city=string.sub(w[2],1,4)
end


----------------------
fq["zhuisha"]=function()
	do_zhuisha(freequest.main,freequest.main)
end

zhuisha={}
zhuisha["ok"]=nil
zhuisha["fail"]=nil

do_zhuisha=function(zhuisha_ok,zhuisha_fail)
	zhuisha["ok"]=zhuisha_ok
	zhuisha["fail"]=zhuisha_fail
	zhuisha.name=""
	zhuisha.city=""
	zhuisha.settris()
	zhuisha.askcmd()
end

zhuisha["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(zhuisha[s])
	end
	zhuisha["ok"]=nil
	zhuisha["fail"]=nil
end

zhuisha_end_ok=function()
	zhuisha["end"]("ok")
end

zhuisha_end_fail=function()
	zhuisha["end"]("fail")
end


zhuisha.settris=function()
	addtri("freequest_on_zhuishaname","^(> )*"..infolist[freequest.info]["name"].."(˵������ѽѽ����˵|˵�������յ���Ϣ�����ϴ��������������Ǽ��£���ı��Ȼ����.*������һ������|�ٺ�һЦ��������������Ȳ���.*��Ҳ����.*������һ����|����˵���������ִ�����Ϣ���ϴ������������ɵ���ı��Ȼ��������ԭ���������ˣ���һ����ʲô|����˵�������������ִ�������Ϣ�������������ɵ���ı��ȻҲ������������һ����)(?P<name>.*)(�Ǽһﲻ֪��ô��ģ���Ȼ�ѽ�������������ȫ�������ˣ��������֣�|���ڱ���ָʹ��|������Ļ��ȫȨ���ݣ�|������ͽ��|������Ļ����ݡ�)","info","freequest_on_zhuishaname",flag_base_temp)
	addtri("freequest_on_zhuishacity","^(> )*"..infolist[freequest.info]["name"].."(˵����Ŷ����˵������������Ѿ���|����˵��������ǰ���쵹����һ�����ڵ���Ъ�ţ���֪��ô�ľ�̸����������˵�����Ƕ㵽|����˵������������������Ҳ���������������յ���Ϣ���Ѿ�ֱ��)(?P<city>.*)(����ȥ�ˡ�|����ȥ�ˣ��ҿ��������С�������ޡ�|ȥ�ˡ�)","info","freequest_on_zhuishacity",flag_base_temp)
end

freequest_on_zhuishaname=function(n,l,w)
	zhuisha.name=w["name"]
	zhuisha.city=""
	info.answer=3
end

freequest_on_zhuishacity=function(n,l,w)
	zhuisha.city=string.sub(w["city"],1,4)
	info.answer=3
end

zhuisha.askcmd=function()
	zhuisha.city=""
	local content="׷ɱ"..freequest.infolist["zhuisha"]
	if zhuisha.name~="" then
		content=content.."."..zhuisha.name
	end
	askinfo(freequest.info,content,freequest.asktimes)
	infoend(zhuisha.askcmdend)
end

zhuisha.askcmdend=function()
	if npc.nobody==1 or info.answer==2 or shen.city=="" then
		 zhuisha_end_ok()
	elseif info.answer==1 then
		zhuisha.askcmd()
	elseif zhuisha.city~="" and zhuisha.name~="" then
		do_killnpcinpath(zhuisha.name,city[zhuisha.city].path,zhuisha.killok,zhuisha.killok)
	elseif info.answer==3 then
		zhuisha.askcmd()
	else
		zhuisha.city=""
		zhuisha.name=""
		zhuisha.askcmd()
	end
end

zhuisha.killok=function()
	_info=freequest.initinfo()
	print(_info)
	zhuisha.settris()
	zhuisha.name=""
	zhuisha.city=""
	go(infolist[_info]["loc"],zhuisha.askcmd,zhuisha_end_fail)
end


---------------------------------------
xunzhaoitem={}
xunzhaoitem["�׽��"]="baijin he"
xunzhaoitem["�����"]="baiyu bi"
xunzhaoitem["���"]="jin gua"
xunzhaoitem["���«"]="jin hulu"
xunzhaoitem["���λ�"]="jinlou hua"
xunzhaoitem["��Ѫʯ"]="jixue shi"
xunzhaoitem["Ǭ��ñ"]="qiankun mao"
xunzhaoitem["��ͭ��"]="qingtong ding"
xunzhaoitem["�ļ�ƿ"]="sijian ping"
xunzhaoitem["������"]="tie guanyin"
xunzhaoitem["������"]="tie ruyi"
xunzhaoitem["ͭϲȵ"]="tong xique"
xunzhaoitem["ҹ�Ɑ"]="ye guangbei"
xunzhaoitem["���λ�"]="yinlou hua"
xunzhaoitem["���"]="yu dai"
xunzhaoitem["���«"]="yu hulu"
xunzhaoitem["��ƿ"]="yu ping"
xunzhaoitem["�Ͻ�"]="zijin chui"
xunzhaoitem["����ɴ"]="ziyun sha"



fq["xunzhao"]=function()
	do_xunzhao(freequest.main,freequest.main)
end

xunzhao={}
xunzhao["ok"]=nil
xunzhao["fail"]=nil

do_xunzhao=function(xunzhao_ok,xunzhao_fail)
	xunzhao["ok"]=xunzhao_ok
	xunzhao["fail"]=xunzhao_fail
	xunzhao.id=xunzhaoitem[freequest.infolist["xunzhao"]]
	if xunzhao.id==nil then
		xunzhao_end_fail()
		return
	end
	xunzhao.npc1=""
	xunzhao.npc2=""
	xunzhao.city1=""
	xunzhao.city2=""
	xunzhao.settris()
	busytest(xunzhao.askcmd)
end

xunzhao.settris=function()
	addtri("freequest_on_xunzhao","^(> )*"..infolist[freequest.info]["name"].."˵������˵(?P<npc1>.*)����"..freequest.infolist["xunzhao"].."������˵��֪��ô�ľ��䵽��(?P<npc2>.*)�����ˡ�","info","freequest_on_xunzhao",flag_base_temp)
	addtri("freequest_on_npc1","^(> )*"..infolist[freequest.info]["name"].."˵����Ŷ����ѽ����˵����(?P<city1>.*)��������"..freequest.infolist["xunzhao"].."�أ�","info","freequest_on_npc1",flag_base_temp)
	addtri("freequest_on_npc2","^(> )*"..infolist[freequest.info]["name"].."˵����Ŷ����ѽ����˵����(?P<city2>.*)����Ҷ�����ȥ�ˣ������������ޣ�","info","freequest_on_npc2",flag_base_temp)
end

freequest_on_xunzhao=function(n,l,w)
	xunzhao.npc1=w["npc1"]
	xunzhao.npc2=w["npc2"]
	info.answer=3
end
freequest_on_npc1=function(n,l,w)
	xunzhao.city1=string.sub(w["city1"],1,4)
	info.answer=3
end
freequest_on_npc2=function(n,l,w)
	xunzhao.city2=string.sub(w["city2"],1,4)
	info.answer=3
end

xunzhao["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(xunzhao[s])
	end
	xunzhao["ok"]=nil
	xunzhao["fail"]=nil
end

xunzhao_end_ok=function()
	xunzhao["end"]("ok")
end

xunzhao_end_fail=function()
	xunzhao["end"]("fail")
end



xunzhao.askcmd=function()
	local content="Ѱ��"..freequest.infolist["xunzhao"]
	if xunzhao.npc1=="" or xunzhao.npc2=="" then
	elseif itemsnum(freequest.infolist["xunzhao"])>0 then
		content=content.."."..xunzhao.npc1
	else
		content=content.."."..xunzhao.npc2
	end
	askinfo(freequest.info,content,freequest.asktimes)
	infoend(xunzhao.askcmdend)
end


xunzhao.askcmdend=function()
	if npc.nobody==1 or info.answer==2 or shen.city=="" then
		 xunzhao_end_ok()
	elseif info.answer==1 then
		xunzhao.askcmd()
	elseif itemsnum(freequest.infolist["xunzhao"])==0 and xunzhao.city2~="" then
		do_killnpcinpath(xunzhao.npc2,city[xunzhao.city2].path,xunzhao.npc2ok,xunzhao.goask)
	elseif itemsnum(freequest.infolist["xunzhao"])>0 and xunzhao.city1~="" then
		npc.name=xunzhao.npc1
		do_npcinpath(city[xunzhao.city1].path,xunzhao.npc1ok,xunzhao.goask)
	elseif info.answer==3 then
		xunzhao.askcmd()
	else
		xunzhao_end_ok()
	end
end

xunzhao.goask=function()
	_info=freequest.initinfo()
	print(_info)
	xunzhao.settris()
	go(infolist[_info]["loc"],xunzhao.askcmd,xunzhao_end_fail)
end

xunzhao.npc1ok=function()
	run("give "..xunzhao.id.." to "..npc.id)
	xunzhao_end_ok()
end

xunzhao.npc2ok=function()
	run("get "..xunzhao.id.." from corpse")
	getstatus(xunzhao.goask)
end

