me={}
me.score={}
me.hp={}
me.fam={"None"}
me.special={}
checkstatus=function()
run("special;who -n -fam;score;league;")
end

score=function()
	me.score={}
	catch("charinfo","score")
end

status_on_score1=function (name, line, wildcards)
	me.score["age"]=ctonum(wildcards[2])
	me.score["sex"]=wildcards[3]
end

status_on_score3=function (name, line, wildcards)
	me.score["����"]=tonumber(wildcards[2])
	if (wildcards[1])=="��" then
		me.score["zhengqi"]=-me.score["zhengqi"]
	end
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
	run("yun recover;yun regenerate;hp")
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
	me.hp.nuqi=wildcards[2]
	if me.hp.nuqi=="ŭ������" or me.hp.nuqi=="�������" then
		me.hp.nuqi=10000
	else
		me.hp.nuqi=tonumber(me.hp.nuqi)
	end
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
	SetTriggerOption ("status_onfamily", "match","^(> )*��"..wildcards[2].."��  Ŀǰ�����е� \\((.*)\\) ����У�")
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
	if chacmd==nil then
		run("cha")
	else
		run(chacmd)
	end
	trigrpoff("cha")
end

status_oncha=function(name, line, wildcards)
	me.skills[wildcards[3]]={name=wildcards[2],lv=tonumber(wildcards[4]),per=tonumber(wildcards[5])}
end

getjifa=function()
	me.jifa={}
	mejifa=me.jifa
	catch("jifa","jifa")
end

preperskillcmd=""
status_onjifa=function(name, line, wildcards)
preperskillcmd=""
	me.jifa[wildcards[2]]={name=wildcards[1],lv=tonumber(wildcards[4]),skillname=wildcards[3]}
	if preperskill[wildcards[2]]~=nil then
		if preperskill[wildcards[2]][wildcards[3]]~=nil then
			preperskillcmd=preperskillcmd..preperskill[wildcards[2]][wildcards[3]]
		end
	end
end


getinfo=function(func)
	gettitle()
	score()
	getjifa()
	cha()
	getspe()
	hp()
	getfam()
	getmudvar()
	infoend(stsetting)
	busytest(func)
end
getstatus=function(func)
	eatdrink()
	run("yun recover;yun regenerate")
	getinv()
	weapondru()
	hp()
	delay(1,func)
end

stsetting=function()
	settags()
	setflylist()
end

nocross=false

settags=function()
	tags=""
	if me.fam~=nil then
		if familys[me.fam]~=nil then
			tags=familys[me.fam].family
		end
	end
	if nocross==true then
		tags=tags.."|nocross"
	end
	if quest.name~="" and quest.name~=nil then
		if quest.savemoney[quest.name]==true then
			tags=tags.."|nocar"
		end
	end
	if housepass[me.name.."����"]~=nil then
		mypass[housepass[me.name.."����"].name]=true
	end
	for i,v in pairs(mypass) do
		tags=tags.."|pass-"..i
	end
	mapper.settags(tags)
end

setflylist=function()
	flist=""
	if me.score.age~=nil then
		if me.score.age<18 then
			flist="recall back:26,"
		end
	end
	wvflylist=GetVariable("flylist")
	if wvflylist~=nil then
		flist=flist..wvflylist
	end
	mapper.setflylist(flist)
end

mejifa=me.jifa

mejifaforcelv=function()
	if me.jifa~=nil then
		if me.jifa.force~=nil then
			return me.jifa.force.lv
		end
	end
	return 0
end
me.name=""
status_onname=function(n,l,w)
	me.name=(w[3])
end

status_onrank=function(n,l,w)
	SetTriggerOption("status_onname","match","^(> )*"..w[2]..".*( |��)((..){1,4})\\(\\w+\\)$")
end

gettitle=function()
	me.name=""
	catch("rank","rank")
end

getinv=function()
	run("i;")
	for i,v in pairs(invbags) do
		getbagitems(i)
	end
end
