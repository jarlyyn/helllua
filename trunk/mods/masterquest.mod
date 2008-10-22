masterquest={}
masterquest["ok"]=nil
masterquest["fail"]=nil
masterquest["npc"]=""
masterquest["npcid"]=""
masterquest["city"]=""
do_masterquest=function(masterquest_ok,masterquest_fail)
	masterquest["ok"]=masterquest_ok
	masterquest["fail"]=masterquest_fail
	setquesttri()
end

masterquest["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(masterquest[s])
	end
	masterquest["ok"]=nil
	masterquest["fail"]=nil
end

masterquest_end_ok=function()
	masterquest["end"]("ok")
end

masterquest_end_fail=function()
	masterquest["end"]("fail")
end
setquesttri=function()
--	SetTriggerOption ("letter_quest", "match", "^(> )*"..familys[me.fam].mastername.."吩咐你在.*之前把信件送到(.*)手中，取回执交差。\\n据闻不久前此人曾经在(.*)。$")
end
--------------------------------

mqfar={}
mqfar["ok"]=nil
mqfar["fail"]=nil

do_mqfar=function(mqfar_ok,mqfar_fail)
	mqfar["ok"]=mqfar_ok
	mqfar["fail"]=mqfar_fail
end

mqfar["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqfar[s])
	end
	mqfar["ok"]=nil
	mqfar["fail"]=nil
end

mqfar_end_ok=function()
	mqfar["end"]("ok")
end

mqfar_end_fail=function()
	mqfar["end"]("fail")
end


------------------------------------

mqask={}
mqask["ok"]=nil
mqask["fail"]=nil

do_mqask=function(mqask_ok,mqask_fail)
	mqask["ok"]=mqask_ok
	mqask["fail"]=mqask_fail
end

mqask["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqask[s])
	end
	mqask["ok"]=nil
	mqask["fail"]=nil
end

mqask_end_ok=function()
	mqask["end"]("ok")
end

mqask_end_fail=function()
	mqask["end"]("fail")
end


----------------------------------

mqkill={}
mqkill["ok"]=nil
mqkill["fail"]=nil
mqkill["searchcount"]=0
mqkill["city"]=""
mqkill["searchmax"]=1
do_mqkill=function(mqkcity,mqkmax,mqkill_ok,mqkill_fail)
	mqkill["ok"]=mqkill_ok
	mqkill["fail"]=mqkill_fail
	mqkill["city"]=mqkcity
	mqkill["searchmax"]=mqkmax
	mqkill["searchcount"]=0
	npc.name=masterquest.npc
	mqkill.main()
end

mqkill["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(mqkill[s])
	end
	mqkill["ok"]=nil
	mqkill["fail"]=nil
end

mqkill_end_ok=function()
	mqkill["end"]("ok")
end

mqkill_end_fail=function()
	mqkill["end"]("fail")
end
mqkill.main=function()
	if mqkill["searchmax"]<mqkill["searchcount"] then
		mqkill_end_ok()
	else
		mqkill["searchcount"]=mqkill["searchcount"]+1
		fightpreper()
		busytest(mqkill.search)
	end
end
mqkill.search=function()
		do_npcinpath(city[mqkill["city"]].path,mqkill.npcfind,mqkill.main)
end

mqkill.npcfind=function()
	do_kill(npc.id,mqkill_end_ok,mqkill.search)
end

-------------------------------------