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
		if (masterquest.far==true or masterquest["city"]=="Î÷Óò") and me.score.yueli>4000 and me.score.weiwang>400 then
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
