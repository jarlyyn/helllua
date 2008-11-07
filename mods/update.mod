version=11
mclversion=tonumber(GetVariable("version"))

if mclversion==nil then 
	mclversion=0
end

addtri=function(triname,trimatch,trigroup,triscript)
	AddTriggerEx(triname, trimatch, "", flag_base, -1, 0, "",  triscript, 0, 100)
	SetTriggerOption(triname,"group",trigroup)
end

flag_base=1064
flag_base_enable=1065

updateversion=function()
	print("����mcl�ļ�")
	addtri("remote","^(> )*[^~].{1,7}\\((.*)\\)�����㣺do (.+)","system","remote_called")
	addtri("cantell",'^can_tell\\s*"(.+)"',"mudvar","mudvar_teller")
	addtri("mqletter","^(> )*(ͻȻһλ|������ಡ���һ��|��ת��һ��|��һ��ͷ|�������뿪|ֻ��������뿪|ֻ����ٿ��ٿ����)(.*)(���Ӽ���ææ������������������ļ��|һ���������㱳�����|������һֻ�ҵ��Ÿ�������ԣ���Ͻ�|ֻ��һλͬ��װ���ĵ�����ͷ�󺹵����˹���|��Ȼ���ֲ�Զ���ĵ���һ��ʯͷ�Ͽ���Щʲô|һλͬ��װ���ĵ���׷������|һֻ�׸���˹������������ͷ)","masterquest","mqletterattive")
	addtri("block_onnpc","^(> )*(.*)(�ȵ�����λ.*���ߣ�|��ǰ��ס�㣬����˵������λ|�ȵ������������䡭������|��ס���㣺|������ס�����һ��˵����ǧ������|��ס��|������������ǰ��˫�ֺ�ʲ˵����|�����ȵ��������̵ģ���Ҫ���|��ס�����û����ү�ķԸ���˭Ҳ���ܽ�ȥ��|��ס��)","system","block_onnpc")
	addtri("mqlettercontent","^(> )*�����͵���(.*?)��(���Ŷ���|������ʿ|������ν����)(.*?)(�Ŵκ���������|��ҽ���|��Ϊ��������)(.*)\\n(.*)��û�����Ǵ�û��Ὣ����ȥ","mqletter","mqlettercontent")
	SetTriggerOption("mqlettercontent","multi_line","1")
	SetTriggerOption("mqlettercontent","lines_to_match","2")
	AddAlias("alias_start","start","",flag_base_enable,"alias_start")
	addtri("mqletterquest","^(> )*���߹��Ը�����(.*)֮ǰ����(.*)����ͷ����(.*)���\\n��˵����ǰ����������(.*)��û��","mqletterquest","mqletterquest")
	SetTriggerOption("mqletterquest","multi_line","1")
	SetTriggerOption("mqletterquest","lines_to_match","2")
	addtri("mqquestnum","^ʦ����������������Ѿ����������\\s*(\\d*)\\s*����","mqquestnum","mqquestnum")
	addtri("mqlettertimeout","^(> )*��(������ü���������һ��ǲ�ȥ�ˣ�����ʦ��|ҡ��ҡͷ�����ź�����һ˺��)","masterquest","mqlettertimeout")
	addtri("unwield","^(> )*��.*������֡�","system","on_unwield")
	addtri("kanbush","^(> )*�����������²��а�","system","kanbush")
	addtri("walk_gwriver","^(> )*(�㿴�ű��ڲ�Ϣ�İ׺ӣ������е���ţ�����������|�������߳�һ�����򣬵����ۿ�����|�������Ա����۵����㿴)","system","gwriver")
	addtri("mqletterflee","^(�����ˣ�(.*)��|������뿪��ͻȻ(.*)����)","mqletterquest","letterflee")
	addtri("giftbaoguofail","^(> )*��������Ķ���ʵ����̫���ˣ����Ⱥú����������ɡ�","giftbaoguofail","giftbaoguofail")
	addtri("enterchatfail","^(> )*(û����������ҡ�|�˼Ҳ���ӭ�㣬�㻹�Ǳ�ȥɨ���ˡ�)","enterchatfail","dropgift_enterchatfail")
	addtri("mudvar_chatroom","^chatroom\\s*=\\s*(.+)","mudvar","mudvar_chatroom")
	addtri("mqhelper1","^(> )*bao(�����ȵ�������һ��|��Ȼ���വ�ڣ������˲���΢΢һ㶡�|һ����Х�������಴������ԶԶ�Ĵ��˿�ȥ��)","masterquestkill","mqhelper1")
	addtri("mqhelper","^(> )*˵ʱ�٣���ʱ�죡ͻȻת��(.*)���ˣ�һ�����ǰ�������������з�����$","mqhelper","mqhelper")
end


if mclversion<version then
	updateversion()
	print("�汾�������")
	SetVariable("version",tostring(version))
	inittri()
end