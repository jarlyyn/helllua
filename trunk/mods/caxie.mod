caxie={}
caxie["inv"]={}
caxie["inv"]["к╒вс"]={max=1,min=1}
caxie["inv"]["п╛см"]={max=7,min=4}
caxie["index"]=1
caxie["finished"]={}
caxie["ok"]=nil
caxie["fail"]=fail
do_caxie=function(caxie_ok,caxie_fail)
	caxie["ok"]=caxie_ok
	caxie["fail"]=caxie_fail
	caxie["main"]()
end
caxie["end"]=function(s)
	if ((s~="")and(s~=nil)) then 
		call(caxie[s]) 
	end
	caxie["ok"]=nil
	caxie["fail"]=nil
end
caxie["main"]=function()
	if quest.stop then
		caxie["end"]()
		return
	end
	getstatus(caxie["check"])
end

caxie["check"]=function()
	if do_check(caxie["main"]) then
	elseif checkitems(caxie["inv"],caxie["main"]) then
	elseif checkstudy(caxie["main"]) then
	else
		caxiebegin(cxpath[caxpathlist[math.random(1,#caxpathlist)]])
	end
end

makecaxielistre=rex.new ("(\\w+\\s\\w+)")
makecaxielist=function()
	eatdrink()
	caxie["list"]={}
	for i,v in pairs(room_obj) do
		strfind=makecaxielistre:exec(i)
		if (strfind~=nil)and(caxie["blacklist"][i]~=true)and(v["num"]<10) then
			for t = 1,v["num"],1 do
				caxie["list"][(#caxie["list"]+1)]=i.." "..tostring(t)
			end
		end
	end
	caxienpc()
end

caxiebegin=function(_cxpath)
	caxie["finished"]={}
	do_steppath(_cxpath,caxiestep,caxie["fail"],caxie["ok"],caxie["fail"])
end
caxienpc=function()
	caxie["index"]=caxie["index"]+1
	if caxie["index"]<=(#caxie["list"]) then
		run("swab "..caxie["list"][caxie["index"]])
		busytest(caxienpc)
	else
		steppath["next"]()
	end
end

caxiestep=function()
	if caxie["finished"][tostring(steppath["nextroom"])]==true then
		steppath["next"]()
	else
		caxie["finished"][tostring(steppath["nextroom"])]=true
		caxie["index"]=0
		busytest(makecaxielist)
	end
end



caxie["blacklist"]={}
caxie.blacklist["Yufeng zhen"]=true
caxie.blacklist["Tie lianzi"]=true
caxie.blacklist["iron blade"]=true
caxie.blacklist["long sword"]=true
