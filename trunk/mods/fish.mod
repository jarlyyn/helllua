test=[[  «‡”„(qingyu)  ≤›”„(caoyu)   ˆÍ”„(ji yu)   À¿≤›”„(si yu)   ¿√”„(lan yu)]]
fish={}
fish["ok"]=nil
fish["fail"]=nil
fish.items={}
fish.items["diao gan"]={max=1,min=1}
fish.items["”„∂¸"]={max=100,min=1}
fish.drops={}
fish.drops["si yu"]="si yu"
fish.drops["lan yu"]="lan yu"
fish.sells={}
fish.sells["qingyu"]={name="qingyu",id="qingyu"}
fish.sells["caoyu"]={name="caoyu",id="caoyu"}
fish.sells["ji yu"]={name="ji yu",id="ji yu"}
fish.sells["liyu"]={name="liyu",id="liyu"}

do_fish=function(fish_ok,fish_fail)
	fish["ok"]=fish_ok
	fish["fail"]=fish_fail
	busytest(fish.main)
end

fish["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(fish[s])
	end
	fish["ok"]=nil
	fish["fail"]=nil
	EnableTriggerGroup("fish",false)
end

fish_end_ok=function()
	fish["end"]("ok")
end

fish_end_fail=function()
	fish["end"]("fail")
end

fish["main"]=function()
	if quest.stop then
		fish["end"]()
		return
	end
	getstatus(fish["check"])
end

fish["check"]=function()
	if do_check(fish["main"]) then
	elseif checkitems(fish.items,fish["main"]) then
	elseif checkdrop(fish.drops,fish["main"],fish["main"]) then
	elseif checksell(fish.sells,fish["main"],fish["main"]) then
	elseif checkfangqi(fish["main"],fish["main"]) then
	elseif checkstudy(fish["main"]) then
	else
		go(fishloc,fish.arrive,fish_end_fail)
	end
end

fish.arrive=function()
	EnableTriggerGroup("fish",true)
	run("fish")
	busytest(fish_end_ok)
end
fish_ondraw=function(n,l,w)
	run("draw diao gan")
end

fish.loop=function()
	busytest(fish.loopcmd)
end

fish.loopcmd=function()
	do_fish(fish.loop,fish.loop)
end
