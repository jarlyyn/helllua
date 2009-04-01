
alias_to=function(...)
	testinfo(alias_tocmd,...)
end

alias_tocmd=function(n,l,w)
	print("go"..mapper.getroomname(w[1]))
	go(w[1]-0)
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
	if w[2]==false then
		print("请输入正确的格式，比如#lian dodge,parry,sword book\n如果带>,比如#lian dodge>start,则在练习完毕后执行指定的指令。\n练习可以用 基本技能.特殊技能 来激发指定的技能练习，比如#lian dodge.feiyan-zoubi,dodge.shenxing-baibian。")
		return
	end
	aliaslianskill=w[2]
	if w[4]~=false then
		aliasliancmd=w[4]
	end
	do_quest("lian")
end

liando=function()
	do_lian(aliaslianskill,liancmd)
end

liancmd=function()
	Execute(aliasliancmd)
end

alias_gonpc=function(...)
	testinfo(alias_gonpccmd,...)
end
alias_gonpccmd=function(n,l,w)
	walk["npc"](w[1])
end

alias_caxie=function(m,l,w)
	do_quest("caxie")
end

alias_beiqi=function(m,l,w)
	do_quest("beiqi")
end
alias_canwu=function(m,l,w)
	do_quest("canwu")
end
alias_dutable=function(m,l,w)
	do_quest("dutable")
end
alias_letter=function(m,l,w)
	do_quest("letter")
end
alias_fish=function(m,l,w)
	do_quest("fish")
end
alias_liandan=function(m,l,w)
	do_quest("liandan")
end
alias_start=function(m,l,w)
	do_quest("mq")
end
alias_dazuoneili=function(m,l,w)
	do_quest("dazuoneili")
end

alias_stop=function(m,l,w)
	quest.stop=true
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


