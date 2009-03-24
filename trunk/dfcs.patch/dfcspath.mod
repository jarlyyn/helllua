--th新路
tiejiangsloc=mapper.newarea(1)
mapper.readroom(tiejiangsloc,tostring(tiejiangsloc).."=大院|th>ride diao*:1986,n:66,")
mapper.readroom(1979,"1979=前院|n:1980,out:1978,")
mapper.readroom(1986,"1986=桃花山庄正门|e:2000,n:2007,s:1987,")
mapper.addpath(1994,"th>ride diao:"..tostring(tiejiangsloc)..",")
mapper.addpath(66,"s:"..tostring(tiejiangsloc)..",")

masterquest.questgive=function()
	initmq()
	run("give head to "..familys[me.fam].masterid..";mastercmd")
	busytest(masterquest.testask)
end

masterquest.giveheadcmd=function()
	run("give head to "..familys[me.fam].masterid..";drop head;mastercmd")
	busytest(masterquest.main)
end

masterquest.case=function()
	if masterquest.die==false and masterquest.npc~="" then
		if (masterquest.far==true or masterquest["city"]=="西域") and me.score.yueli>4000 and me.score.weiwang>400 then
				initmq()
				busytest(masterquest.askquest)
		elseif masterquest.far==true then
			busytest(mqfar.main)
		elseif masterquest.flee==true then
			do_mqask(masterquest.maincmd,masterquest.findfar)
		else
			do_mqkill(masterquest["city"],3,masterquest_end_ok,masterquest.asknpc)
		end
	elseif checkstudy(masterquest["main"],masterquest["main"]) then
	else
		masterquest.askquest()
	end
end

checkbow=function(check_ok,check_fail)
	if getnum(me.hp.exp<50000) or getnum(me.hp.exp>400000) then return false end
	if GetVariable("pfm")=="shot" and itemsnum("狼牙箭")<10 then
		item["go"]("狼牙箭",30,check_ok,check_fail)
		return true
	elseif GetVariable("pfm")=="shot" and itemsnum("点金盘龙弓")==0 and itemsnum("长弓")==0 and itemsnum("短弓")==0 and itemsnum("赤鸳弩")==0 and itemsnum("弩")==0 then
		item["go"]("长弓",1,check_ok,check_fail)
		return true
	end
	return false
end
