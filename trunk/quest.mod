quest={}
questend={}
quest.stop=true

include("caxie.mod")
quest["caxie"]=function()
	do_caxie(caxie.main)
end
questend["caxie"]=function()
	caxie["end"]()
end
do_quest=function(name)
	initmud()
	if quest[name]~=nil then
		quest.stop=false
		getinfo()
		quest[name]()
	end
end

initmud=function()
	run(mudsettings)
end