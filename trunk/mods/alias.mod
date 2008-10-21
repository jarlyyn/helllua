alias_to=function(n,l,w)
	print("go"..mapper.getroomname(w[1]))
	go(w[1]-0)
end

alias_spwk=function(n,l,w)
	walk["stop"]()
end

alias_stopto=function(n,l,w)
	go(w[1]-0)
end

alias_gonpc=function(n,l,w)
	walk["npc"](w[1])
end
	
alias_caxie=function(m,l,w)
	do_quest("caxie")
end

alias_beiqi=function(m,l,w)
	do_quest("beiqi")
end
alias_letter=function(m,l,w)
	do_quest("letter")
end
alias_fish=function(m,l,w)
	do_quest("fish")
end
alias_stop=function(m,l,w)
	quest.stop=true
end