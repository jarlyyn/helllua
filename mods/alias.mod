_aftercmd=""
getaftercmd=function(str)
local l=string.find(str,">")
	if l== nil then
		_aftercmd=""
		return str
	else
		_aftercmd=string.sub(str,l+1,#str)
		return string.sub(str,1,l-1)
	end
end

aliasaftercmd=function()
	if _aftercmd=="" then return end
	print ("执行结束后命令：".._aftercmd.."。")
	Execute(_aftercmd)
end

alias_do=function(n,l,w)
	print(w[1])
	w[1]=getaftercmd(w[1])
	Execute(w[1])
	busytest(aliasaftercmd)
end

alias_to=function(...)
	testinfo(alias_tocmd,...)
end

alias_tocmd=function(n,l,w)
	w[1]=getaftercmd(w[1])
	if tonumber(w[1])~=nil then
		w[1]=tonumber(w[1])
		print("go"..mapper.getroomname(w[1]))
		go(w[1]-0,aliasaftercmd,aliasaftercmd)
		return
	elseif w[1]~=nil and w[1]~="" then
		walk["npc"](w[1],aliasaftercmd,aliasaftercmd)
		return
	end
	print("请输入正确格式\n#to loc或者#to npc。\n支持>指定到达位置或者失败后的下一步动作\n比如#to 26>start")
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
	else
		aliasliancmd=""
	end
	do_quest("lian")
end

alias_assist=function(n,l,w)
	if w[1]==false then
		print("进入被协助状态。如要协助他人，请输入#assist 对方id")
		do_quest("assistor")
	else
		print("进入协助状态。如要被他人协助，请输入#assist")
		do_quest("assister",w[2])
	end
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


