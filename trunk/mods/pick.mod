pick={}
pick["inv"]={}
pick["index"]=1
pick["ok"]=nil
pick["fail"]=fail
pick.full=false
do_pick=function(pick_ok,pick_fail)
	pick["ok"]=pick_ok
	pick["fail"]=pick_fail
	EnableTriggerGroup("pick",true)
	busytest(pick["main"])
end
pick["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(pick[s])
	end
	EnableTriggerGroup("pick",false)
	pick["ok"]=nil
	pick["fail"]=nil
end
pick["main"]=function()
	if quest.stop then
		pick["end"]()
		return
	end
	getstatus(pick["check"])
end

pick["check"]=function()
	if do_check(pick["main"]) then
	elseif checksell(picklist,pick["main"]) then
	else
		pickbegin(cxpath[caxpathlist[math.random(1,#caxpathlist)]])
	end
end

makepicklist=function()
	eatdrink()
	pick["list"]={}
	for i,v in pairs(room_obj) do
		if picklist[i]~=nil then
			for t = 1,v["num"],1 do
				pick["list"][(#pick["list"]+1)]=i
			end
		end
	end
	pickitem()
end

pickbegin=function(_cxpath)
	pick.full=false
	do_steppath(_cxpath,pickstep,pick["fail"],pick["ok"],pick["fail"])
end
pickitem=function()
	pick["index"]=pick["index"]+1
	if pick["index"]<=(#pick["list"]) then
		run("get "..picklist[pick["list"][pick["index"]]].id)
		busytest(pickitem)
	else
		if pick.full==true then
			busytest(pickinvfull)
		else
			steppath["next"]()
		end
	end
end

pickinvfull=function()
	steppath["end"]("ok")
end

pick_full=function(n,l,w)
	if w[2]==picklist[pick["list"][pick["index"]]].cname then
		pick.full=true
	end
end

pickstep=function()
	pick["index"]=0
	busytest(makepicklist)
end


picklist={}
picklist["yin lun"]={name="yin lun",id="yin lun",cname="ÒøÂÖ"}
picklist["long sword"]={name="long sword",id="long sword",cname="³¤½£"}
picklist["iron blade"]={name="iron blade",id="iron blade",cname="¸Öµ¶"}
picklist["gangzhang"]={name="gangzhang",id="gangzhang",cname="¸ÖÕÈ"}


