mudvar={}
initmudvar=function()
	mudvar.teller=""
	chatroom=""
	mudvar.eatjz=false
end

getmudvar=function()
	initmudvar()
	catch("mudvar","set;alias")
end

mudvar_teller=function(n,l,w)
	print("ң���ߣ�"..w[1])
	mudvar.teller=w[1]
end

mudvar_chatroom=function(n,l,w)
	print("�����ң�"..w[1])
	chatroom=w[1]
end

mudvar_eatjz=function(n,l,w)
	mudvar.eatjz=true
end
