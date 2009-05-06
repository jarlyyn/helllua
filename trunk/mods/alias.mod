_aftercmd=""
_nowcmd=""
getaftercmd=function(str,str2)
	if str==nil or str==false then
		_aftercmd=""
		return nil
	end
	local l=string.find(str,">")
	if l== nil then
		_aftercmd=""
		return str
	else
		if str2~=nil then
			_nowcmd=str2
			quest.stop=false
			quest.resume=aliasaftercmdresume
		end
		_aftercmd=string.sub(str,l+1,#str)
		return string.sub(str,1,l-1)
	end
end

aliasaftercmdresume=function()
	if _nowmcmd=="" then quest.stop=true end
	print(_nowcmd)
	Execute(_nowcmd)
end

aliasaftercmd=function()
	if _aftercmd=="" then
		if _nowmcmd~="" then
			quest.stop=true
			_nowmcmd=""
		end
		return
	end
	print ("ִ�н��������".._aftercmd.."��")
	busytest(Execute,1,_aftercmd)
end

alias_setvalue=function(n,l,w)
	w[3]=getaftercmd(w[3],w[0])
	if w[2]=="" or w[2]==false then
		print("��ʽ������ȷ��ʽΪ��#set ������ ����ֵ��ע��,mush����Ҫ��;;����ʾ;����Ȼmush���ϳɷ��С�")
		busytest(aliasaftercmd)
		return
	end
	SetVariable(w[2],w[3])
	busytest(aliasaftercmd)
end

alias_check=function(n,l,w)
	w[1]=getaftercmd(w[1],w[0])
	testinfo(alias_check_getstatus)
end

alias_check_getstatus=function()
	getstatus(alias_check_case)
end


alias_re_cmd=""
alias_re=function(n,l,w)
	if not(w[2]==false or w[2]==nil or w[2]=="") then
		alias_re_cmd=w[2]
	end
	if alias_re_cmd~="" and alias_re_cmd~="#re" then
		busytest(Execute,1,alias_re_cmd)
	end
end


alias_check_case=function()
	if do_check(alias_check_getstatus,alias_check_getstatus) then
	elseif checkstudy(alias_check_getstatus,aliasaftercmd) then
	else
		busytest(aliasaftercmd)
	end
end

alias_do=function(n,l,w)
	print(w[1])
	w[1]=getaftercmd(w[1],w[0])
	Execute(w[1])
	busytest(aliasaftercmd)
end

alias_to=function(...)
	testinfo(alias_tocmd,...)
end

alias_tocmd=function(n,l,w)
	w[1]=getaftercmd(w[1],w[0])
	if tonumber(w[1])~=nil then
		w[1]=tonumber(w[1])
		print("go"..mapper.getroomname(w[1]))
		go(w[1]-0,aliasaftercmd,aliasaftercmd)
		return
	elseif w[1]~=nil and w[1]~="" then
		walk["npc"](w[1],aliasaftercmd,aliasaftercmd)
		return
	end
	print("��������ȷ��ʽ\n#to loc����#to npc��\n֧��>ָ������λ�û���ʧ�ܺ����һ������\n����#to 26>start")
end

alias_spwk=function(n,l,w)
	unhookall()
	inittri()
end

alias_stopto=function(...)
	testinfo(alias_stoptocmd,...)
end
alias_stoptocmd=function(n,l,w)
	go(w[1]-0)
end

alias_lian=function(n,l,w)
	w[1]=getaftercmd(w[1])
	if w[1]==false then
		print("��������ȷ�ĸ�ʽ������#lian dodge,parry,sword book\n�����>,����#lian dodge>start,������ϰ��Ϻ�ִ��ָ����ָ�\n��ϰ������ ��������.���⼼�� ������ָ���ļ�����ϰ������#lian dodge.feiyan-zoubi,dodge.shenxing-baibian��")
		busytest(aliasaftercmd)
		return
	end
	do_quest("lian",w[1])
end

alias_assist=function(n,l,w)
	if w[1]==false then
		print("���뱻Э��״̬����ҪЭ�����ˣ�������#assist �Է�id")
		do_quest("assistor")
	else
		print("����Э��״̬����Ҫ������Э����������#assist")
		do_quest("assister",w[2])
	end
end

alias_gonpc=function(...)
	testinfo(alias_gonpccmd,...)
end
alias_gonpccmd=function(n,l,w)
	walk["npc"](w[1])
end

alias_caxie=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("caxie",tonumber(w[1]))
end

alias_beiqi=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("beiqi",w[1])
end
alias_canwu=function(m,l,w)
	do_quest("canwu")
end
alias_dutable=function(m,l,w)
	do_quest("dutable")
end
alias_letter=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("letter",tonumber(w[1]))
end
alias_fish=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("fish",tonumber(w[1]))
end
alias_liandan=function(m,l,w)
	do_quest("liandan")
end
alias_start=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("mq",tonumber(w[1]))
end
alias_dazuoneili=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	do_quest("dazuoneili",tonumber(w[1]))
end


npclocre=rex.new("(?<id>[^@]*)(@(?<loc>.*)){0,1}")
alias_kill=function(m,l,w)
	w[1]=getaftercmd(w[1],w[0])
	s,e,t=npclocre:match(w[1])
	print(t.id)
	print(t.loc)
	if t.id==nil or t.id==false or t.id=="" then
		busytest(aliasaftercmd)
		return
	end
	do_killnpc(t.id,tonumber(t.loc),aliasaftercmd,aliasaftercmd)
end


alias_stop=function(m,l,w)
	quest.stop=true
	alias_re_cmd=""
end
alias_kl=function(m,l,w)
	if w[2]~=nil then
		if city[w[2]]~=nil then
			print("go"..w[2].."kill"..w[1])
			initmq()
			masterquest.npc=w[1]
			do_mqkill(w[2],1)
		end
	end
end

alias_pick=function(n,l,w)
	do_quest("pick")
end
