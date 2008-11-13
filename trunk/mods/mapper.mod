assert  (package.loadlib (luapath.."mapper.dll","luaopen_mapper")) ()
mapper={}
mapper.id=mushmapper.getid(GetWorldID())
mapper.open=function(roomsall)
	return mushmapper.openmap(mapper.id,roomsall)
end
mapper.getpath=function(r,t,f)
	return mushmapper.getpath(mapper.id,r,t,f)
end
mapper.getroomid=function(r)
	return mushmapper.getroomid(mapper.id,r)
end

mapper.getexits=function(r)
	return mushmapper.getexits(mapper.id,r)
end
mapper.settags=function(t)
	print(t)
	return mushmapper.settags(mapper.id,t)
end
mapper.setflylist=function(f)
	return mushmapper.setflylist(mapper.id,f)
end

mapper.getroomname=function(r)
	return mushmapper.getroomname(mapper.id,r)
end

mapper.addpath=function(r,p)
	mushmapper.addpath(mapper.id,r,p)
end

mapper.newarea=function(i)
	return mushmapper.newarea(mapper.id,i)
end
mapper.readroom=function(r,s)
	mushmapper.readroom(mapper.id,r,s)
end
