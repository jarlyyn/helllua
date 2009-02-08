skilllistre=rex.new("^(?<skill>.+?)(\\((?<study>[[:alpha:]]+){0,1}?(-{0,1}(?<npc>[[:alpha:]]+\\s+[[:alpha:]]+)){0,1}(-{0,1}(?<npcname>[^a-zA-Z1-9 ]+)){0,1}(-{0,1}(?<loc>\\d+)){0,1}\\)){0,1}$")
study={}
study["skill"]=nil
study["ok"]=nil
study["fail"]=nil
checkstudy=function(checkok)
	if needstudy() then
		do_study(checkok,checkok)
		return true
	else
		return false
	end
end
needstudy=function()
	potmax=GetVariable("potmax")
	if potmax==nil then
		potmax=0
	else
		potmax=tonumber(potmax)
	end
	if (potmax>0) and me.hp.pot>potmax then
		return true
	else
		return false
	end
end
do_study=function(study_ok,study_fail)
	study["ok"]=study_ok
	study["fail"]=study_fail
	if study.skill==nil then
		study_end_fail()
		return
	end
	lastpot=0
	lastpotcount=0
	if study[study.skill.study]~=nil then
		study[study.skill.study]()
	else
		study["end"]("fail")
	end
end

study_end_fail=function()
	study["end"]("fail")
end

study["arrive"]=function()

end

study["end"]=function(s)
	setupskill()
	cha()
	if ((s~="")and(s~=nil)) then
		infoend(study[s])
	end
	study["ok"]=nil
	study["fail"]=nil
end

study["xue"]=function()
	go(study.skill.loc,study["xuecmd"],study_end_fail)
end

study["xuecmd"]=function()
	if (me.hp.pot==0)or((me.hp.neili==0)and(me.hp.neilimax~=0))or(lastpotcount>7) then
		study["end"]("ok")
	else
		if me.hp.pot==lastpot then
			lastpotcount=lastpotcount+1
		else
			lastpot=me.hp.pot
			lastpotcount=1
		end
		if getnum(me.hp.pot)<100 then
			pots=me.hp.pot
		else
			pots=100
		end
		catch("study","xue "..study.skill.npc.." about "..study.skill.skill.." "..tostring(pots))
		hp()
		delay(1,study["xuecmd"])
	end
end

study["jingxiu"]=function()
	if me.fam=="武当派" or me.fam=="全真教" then
		go(familys[me.fam].dazuoloc,study["jingxiucmd"],study_end_fail)
	else
		busytest(study_end_fail)
	end
end

study["jingxiucmd"]=function()
	if (me.hp.pot==0)or((me.hp.neili==0)and(me.hp.neilimax~=0))or(lastpotcount>3) then
		study["end"]("ok")
	else
		if me.hp.pot==lastpot then
			lastpotcount=lastpotcount+1
		else
			lastpot=me.hp.pot
			lastpotcount=1
		end
		if getnum(me.hp.pot)<100 then
			pots=me.hp.pot
		else
			pots=100
		end
		catch("study","jingxiu "..tostring(pots))
		hp()
		delay(1,study["jingxiucmd"])
	end
end

study["yanjiu"]=function()
	settags()
	go(2501,study.yanjiucmd,study.yanjiufail)
end

study["yanjiucmd"]=function()
	if (me.hp.pot==0)or((me.hp.neili==0)and(me.hp.neilimax~=0))or(lastpotcount>7) then
		study["end"]("ok")
	else
		if me.hp.pot==lastpot then
			lastpotcount=lastpotcount+1
		else
			lastpot=me.hp.pot
			lastpotcount=1
		end
		if getnum(me.hp.pot)<100 then
			pots=me.hp.pot
		else
			pots=100
		end
		catch("study","yanjiu "..study.skill.skill.." "..tostring(pots))
		hp()
		delay(1,study["yanjiucmd"])
	end

end
study["yanjiufail"]=function()
	go(-2,study.yanjiucmd,study_end_fail)
end

getdefalutstudy=function()
	if study.skill.npc~=false or study.skill.npcname~=false then
		return "xue"
	else
		if getnum(tonumber(GetVariable("expmax")))<800000 then
			return "xue"
		else
			return "yanjiu"
		end
	end
end

getskillloc=function()
	if study.skill.study=="xue" then
		return study.skill.loc
	end
end
getskill=function(str)
	s,e,t=skilllistre:match(str)
	return t
end
splitre=rex.new("([^;,|]+)")
setupskill=function()
	skilllist=GetVariable("skilllist")
	if skilllist==nil then skilllist="" end
	study["skill"]={}
	local _skills={}
	local i=0
	n=splitre:gmatch(skilllist,function (m, t)
		i=i+1
		_skills[i]=m
	end)
	if i==0 then study.skill=nil end
	study["skill"]=getskill(_skills[math.random(1,i)])
	if study["skill"]~=nil then
		if study.skill.skill=="jingxiu" then
			study.skill.loc=0
			study.skill.npc=""
			study.skill.study="jingxiu"
			return
		end
		if study.skill.study==false then study.skill.study=getdefalutstudy() end
		if study.skill.npc~=false then
			if npcs[study.skill.npc]==nil then
				study.skill.npc=false
			end
		end
		if study.skill.loc==false then study.skill.loc=0 end
		if study.skill.npc==false then
			if npcs[study.skill.npcname]~=nil then
				study.skill.npc=npcs[study.skill.npcname].id
			end
		end
		if study.skill.npc==false then
			if me.fam~=nil then
				if me.score.teacher~="none" and me.score.teacher~=nil then
					study.skill.npc=npcs[me.score.teacher].id
				end
			end
		end
		if study.skill.npc==false then
			study.skill.npc=""
		else
			study.skill.loc=npcs[study.skill.npc]["loc"]
		end
	end
end

study_fail=function(n,l,w)
	lastpotcount=8
end

study_needweapon=function(n,l,w)
	weapon(3)
end
