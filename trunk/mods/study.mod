skilllistre=rex.new("^(?<skill>.+?)(\\((?<study>[[:alpha:]]+){0,1}?(-{0,1}(?<npc>[[:alpha:]]+\\s+[[:alpha:]]+)){0,1}(-{0,1}(?<npcname>[^a-zA-Z1-9 ]+)){0,1}(-{0,1}(?<loc>\\d+)){0,1}\\)){0,1}$")
study={}
study["skill"]={}
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
		study["end"]("fail")
		return
	end
	lastpot=0
	lastpotcount=0
	go(study.skill.loc,study["arrive"],study_go_gail)
end

study_go_gail=function()
	study["end"]("fail")
end

study["arrive"]=function()
	if study[study.skill.study]~=nil then
		study[study.skill.study]()
	else
		study["end"]("fail")
	end
end

study["end"]=function(s)
	if ((s~="")and(s~=nil)) then 
		call(study[s]) 
	end
	setupskill()
	study["ok"]=nil
	study["fail"]=nil
end

study["xue"]=function()
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
		run("xue "..study.skill.npc.." about "..study.skill.skill.." "..tostring(pots))
		hp()
		infoend(studypots)
	end
end

studypots=function()
	delay(1,study["arrive"])
end

getdefalutstudy=function()
	if study.skill.npc~=false then
		return "xue"
	else
		if getnum(me.hp.exp)<800000 then
			return "xue"
		else
			return "yan jiu"
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
		if study.skill.study==false then study.skill.study=getdefalutstudy() end
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