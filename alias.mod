go=walk["stopto"]

alias_to=function(n,l,w)
	print("go"..mushmapper.getroomname(w[1]))
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
