caxie={}
caxie["blacklist"]={}
caxie["inv"]={}
caxie["inv"]["к╒вс"]={max=1,min=1}
caxie["inv"]["п╛см"]={max=7,min=4}
caxie["index"]=1
do_caxie=function(caxie_ok,caxie_fail)

end
caxie["main"]=function()
	run("i;hp;score")
	busytest(caxie["check"])
end

caxie["check"]=function()
	if do_check(caxie["main"]) then
	elseif checkitems(caxie["inv"],caxie["main"]) then
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
		if (strfind~=nil)and(caxie["blacklist"]["i"]~=true) then
			for t = 1,v["num"],1 do
				caxie["list"][(#caxie["list"]+1)]=i.." "..tostring(t)
			end
		end
	end
	caxienpc()
end
caxiebegin=function(_cxpath)
	do_steppath(_cxpath,caxiestep,caxie["fail"],caxie["main"],caxie["fail"])
end
caxienpc=function()
	caxie["index"]=caxie["index"]+1
	if caxie["index"]<=(#caxie["list"]) then
		run("caxie "..caxie["list"][caxie["index"]])
		busytest(caxienpc)
	else
		steppath["next"]()
	end
end

caxiestep=function()
	
	caxie["index"]=0
	busytest(makecaxielist)
end