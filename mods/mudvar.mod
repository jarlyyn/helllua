mudvar={}
initmudvar=function()
	mudvar.teller=""
end

getmudvar=function()
	initmudvar()
	catch("mudvar","set")
end

mudvar_teller=function(n,l,w)
	print("Ò£¿ØÕß£º"..w[1])
	mudvar.teller=w[1]
end