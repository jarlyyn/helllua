caxie={}
caxie["blacklist"]={}
caxie["inv"]={}
caxie["к╒вс"]={max=1,min=1}
caxie["п╛см"]={max=7,min=4}
caxie["index"]=1
caxie["main"]=function()
	run("i;hp;score")
	if caxie["check"] then
	else
	end
end
caxie["check"]=function()
	if check(caxie[main]) then
	elseif checkitems(caxie["inv"],caxie["main"]) then
	else
		return false
	end
	return true
end
makecaxielist=function()
	caxie["list"]={}
	for i,v in pairs(room_obj) do
		strfind=string.find(i," ",1,true)
		if (strfind~=nil)and(caxie["blacklist"]["i"]~=true) then
			for t = 1,v["num"],1 do
				caxie["list"][(#caxie["list"]+1)]=i.." "..tostring(t)
			end
		end
	end
	caxienpc()
end
caxiebegin=function(_cxpath)
	do_steppath(_cxpath,caxiestep,caxie["fail"],caxie["ok"],caxie["fail"])
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