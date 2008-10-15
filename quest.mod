quest={}
quest.stop=true

include("caxie.mod")
quest["caxie"]=function()
	do_caxie(caxie.main)
end

do_quest=function(name)
	if quest[name]~=nil then
		quest.stop=false
		getinfo()
		quest[name]()
	end
end
