blocker={}
blocker["��ͨ"]={id="xu tong",exp=50000}
blocker["����"]={id="xu ming",exp=50000}
blocker["��ͨ����"]={id="xu tong",exp=50000}
blocker["��������"]={id="xu ming",exp=50000}
blocker["Уξ"]={id="xiao wei",exp=50000}
blocker["�ɻ���"]={id="caihua zi",exp=0}
blocker["����"]={id="ya yi",exp=50000}
blocker["ժ����"]={id="zhaixing zi",exp=800000}
blocker["��������"]={id="shi wei",exp=50000}
blocker["����"]={id="ao bai",exp=200000}
blocker["����"]={id="xin yan",exp=790000}
blocker["���"]={id="zhou yi",exp=790000}
blocker["���ĸ�"]={id="jiang sigen",exp=790000}
blocker["ʯ˫Ӣ"]={id="shi shuangying",exp=790000}
blocker["������"]={id="wei chunhua",exp=790000}
blocker["���Э"]={id="yang chengxie",exp=790000}
blocker["����곤��һ�ڣ�"]={id="xu tianhong",exp=790000}
blocker["����־����"]={id="chang bozhi",exp=790000}
blocker["����־"]={id="chang hezhi",exp=790000}
blocker["������һ��"]={id="an jiangang",exp=790000}
blocker["�Ͻ���һ��"]={id="meng jianxiong",exp=790000}
blocker["�԰�ɽЦ������"]={id="zhao banshan",exp=790000}
blocker["����Ӣ"]={id="zhou zhongying",exp=790000}
blocker["½����"]={id="lu feiqing",exp=790000}
blocker["�޳�"]={id="wuchen daozhang",exp=1190000}



block_onnpc=function(n,l,w)
	print(w[2])
--	if not(hashook(hooks.steptimeout)) then return end
	if not(hashook(hooks.step)) then return end
	if blocker[w[2]]==nil then return end
	if blocker[w[2]].exp>getnum(me.hp.exp) then
		if not hashook(hooks.steptimeout) then
			delay(1,walkagain)
		end
		return
	end
	if GetVariable("pfm")==nil or GetVariable("pfm")=="" then return end
	fightpreper()
	do_kill(blocker[w[2]].id,block_step,block_step)
end
block_step=function()
	run(walking.step)
end

walkagain=function()
	eatdrink()
	run(walking["step"])
end
