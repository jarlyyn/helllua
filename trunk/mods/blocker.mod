blocker={}
blocker["虚通"]={id="xu tong",exp=50000}
blocker["虚明"]={id="xu ming",exp=50000}
blocker["校尉"]={id="xiao wei",exp=50000}
blocker["采花子"]={id="caihua zi",exp=50000}
blocker["衙役"]={id="ya yi",exp=50000}
blocker["摘星子"]={id="zhaixing zi",exp=800000}
blocker["鳌府侍卫"]={id="ya yi",exp=50000}
blocker["鳌拜"]={id="ya yi",exp=200000}



block_onnpc=function(n,l,w)
	if not(hashook(hooks.steptimeout)) then return end
	if not(hashook(hooks.step)) then return end
	if blocker[w[2]]==nil then return end
	if blocker[w[2]].exp>getnum(me.hp.exp) then return end
	if GetVariable("pfm")==nil or GetVariable("pfm")=="" then return end
	fightpreper()
	do_kill(blocker[w[2]].id,block_step,_hooklist[hooks.steptimeout])
end
block_step=function()
	run(walking.step)
end