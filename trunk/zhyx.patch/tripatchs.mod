	addtri("system_login",'Ŀǰ���� \\d* λ��ʦ��\\d* λ��������ϣ��Լ� \\d* λʹ���߳��������С�',"system","system_login")

-- ����hp

status_onhpwater=function(name, line, wildcards)
	me.hp["water"]=tonumber(wildcards[1])
	me.hp["watermax"]=tonumber(wildcards[2])
	me.hp["tihui"]=tonumber(wildcards[3])
end

status_onhptihui=function(name, line, wildcards)
	me.hp.nuqi=wildcards[2]
	if me.hp.nuqi=="ŭ������" or me.hp.nuqi=="�������" then
		me.hp.nuqi=10000
	else
		me.hp.nuqi=tonumber(me.hp.nuqi)
	end
	me.hp["exp"]=tonumber(wildcards[3])
end


	addtri("status_onhpwater",'^�� �� ˮ ��\\s*(\\d+)/\\s*(\\d+)\\s*�� �� �� ��(.*)$',"hp","status_onhpwater")
	addtri("status_onhptihui",'^(�� ƽ �� ��|�� �� ŭ ��)\\s*([^/ ]*).*�� �� �� ��\\s*(\\d+)$',"hp","status_onhptihui")

--- ����score
	addtri("noteacher",'^  ��.*������(.*)����û�а�ʦ��',"charinfo","status_noteacher")
	addtri("score1",'^  (����һλ(.*)��.*�µ�(.*)�ԣ�.*����)',"charinfo","status_on_score1")
	addtri("score3",'^  (��|а)    ����\\s*(\\d+)',"charinfo","status_score3")
	addtri("status_onname",'^ ��\\S*��(\\S*) ((..){1,4})\(\w+\)$',"charinfo","status_onname")
	addtri("status_onyueli",'^  ����������\\s*(\\d+)\\s*����������\\s*(\\d+)\\s*$',"charinfo","status_onyueli")
	addtri("status_teacher",'^  ��.*������(.*)��ʦ����(.*)��',"charinfo","status_on_teacher")
