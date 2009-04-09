setflylist=function()
	flist=""
	--if me.score.age~=nil then
	if itemsnum("fly bag")~=0 then
		print("找到新手包")
		flist="flyup:4177,"
	end
	wvflylist=GetVariable("flylist")
	if wvflylist~=nil then
		flist=flist..wvflylist
	end
	mapper.setflylist(flist)
end


itemlist=titemlist
getinv=function()
	titemlist={}
	itemlist=titemlist
	catch("items","i")
	for i,v in pairs(invbags) do
		getbagitems(i)
	end
end
