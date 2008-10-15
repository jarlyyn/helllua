me={}
me.score={}
me.hp={}
me.fam={"None"}
checkstatus=function()
run("special;who -n -fam;score;league;")
end

score=function()
	me.score={}
	EnableTriggerGroup("charinfo",true)
	run("score")
end

status_on_score1=function (name, line, wildcards)
	me.score["age"]=ctonum(wildcards[2])
	me.score["sex"]=wildcards[3]
end

status_on_score3=function (name, line, wildcards)
	me.score["正气"]=tonumber(wildcards[2])
	if (wildcards[1])=="负" then
		me.score["zhengqi"]=-me.score["zhengqi"]
	end
	EnableTriggerGroup("charinfo",false)
end

status_on_teacher=function (name, line, wildcards)
	me.score["xingge"]=wildcards[1]
	me.score["teacher"]=wildcards[2]
end
status_noteacher=function (name, line, wildcards)
	me.score["xingge"]=wildcards[1]
	me.score["teacher"]="none"
end

status_onyueli=function(name, line, wildcards)
	me.score["yueli"]=tonumber(wildcards[1])
	me.score["weiwang"]=tonumber(wildcards[2])
end

hp=function()
	me.hp={}
	trigrpon("hp")
	run("hp")
	trigrpoff("hp")
end

status_onhpjinqi=function(name, line, wildcards)
	me.hp["jinqi"]=tonumber(wildcards[1])
	me.hp["jinqimax"]=tonumber(wildcards[2])
	me.hp["jinqi%"]=tonumber(wildcards[3])
	me.hp["jinli"]=tonumber(wildcards[4])
	me.hp["jinlimax"]=tonumber(wildcards[5])
	me.hp["+jinqi"]=tonumber(wildcards[6])
end

status_onhpqixue=function(name, line, wildcards)
	me.hp["qixue"]=tonumber(wildcards[1])
	me.hp["qixuemax"]=tonumber(wildcards[2])
	me.hp["qixue%"]=tonumber(wildcards[3])
	me.hp["neili"]=tonumber(wildcards[4])
	me.hp["neilimax"]=tonumber(wildcards[5])
	me.hp["jiali"]=tonumber(wildcards[6])
end

status_onhpfood=function(name, line, wildcards)
	me.hp["food"]=tonumber(wildcards[1])
	me.hp["foodmax"]=tonumber(wildcards[2])
	me.hp["pot"]=tonumber(wildcards[3])
end

status_onhpwater=function(name, line, wildcards)
	me.hp["water"]=tonumber(wildcards[1])
	me.hp["watermax"]=tonumber(wildcards[2])
	me.hp["exp"]=tonumber(wildcards[3])
end

status_onhptihui=function(name, line, wildcards)
	me.hp["tihui"]=tonumber(wildcards[3])
end

getfam=function()
	me.fam="None"
	trigrpon("whofam")
	run("time;who -n -fam")
	trigrpoff("whofam")
end

status_onfamily=function(name, line, wildcards)
	me.fam=wildcards[2]
end

status_mudname=function(name, line, wildcards)
	me.mudname=wildcards[2]
	SetTriggerOption ("status_onfamily", "match","^(> )*◎"..wildcards[2].."◎  目前江湖中的 \\((.*)\\) 玩家有：")
end

status_onspecial=function(name, line, wildcards)
	me.special[wildcards[2]]=true
end

getspe=function()
	me.special={}
	trigrpon("special")
	run("special")
	trigrpoff("special")
end

cha=function()
	me.skills={}
	trigrpon("cha")
	run("cha")
	trigrpoff("cha")
end

status_oncha=function(name, line, wildcards)
	me.skills[wildcards[3]]={name=wildcards[2],lv=tonumber(wildcards[4]),per=tonumber(wildcards[5])}
end

getjifa=function()
	me.jifa={}
	catch("jifa","jifa")
end

status_onjifa=function(name, line, wildcards)
	me.jifa[wildcards[2]]={name=wildcards[1],lv=tonumber(wildcards[4]),skillname=wildcards[3]}
end

getstatus=function()
hp()
end

getinfo=function()
	score()
	getjifa()
	cha()
	getspe()
	getfam()
end

settags=function()
	tags=""
	if me.fam~=nil then
		tags=tags..me.fam
	end
		mushmapper.settags(tags)
end
