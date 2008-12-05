version=30
mclversion=tonumber(GetVariable("version"))

if mclversion==nil then
	mclversion=0
end

addtri=function(triname,trimatch,trigroup,triscript)
	AddTriggerEx(triname, trimatch, "", flag_base, -1, 0, "",  triscript, 0, 100)
	SetTriggerOption(triname,"group",trigroup)
end

flag_base=1064
flag_base_enable=1065

addvar=function(varname,def_value)
	if GetVariable(varname)==nil then
		SetVariable(varname,def_value)
	end
end

updateversion=function()
	print("升级mcl文件")
	addtri("remote","^(> )*[^~].{1,7}\\((.*)\\)告诉你：do (.+)","system","remote_called")
	addtri("cantell",'^can_tell\\s*"(.+)"',"mudvar","mudvar_teller")
	addtri("mqletter","^(> )*(突然一位|忽听“嗖”的一声|你转身一看|你一回头|你正欲离开|只见你刚想离开|只听扑倏扑倏几声)(.*)(弟子急急忙忙地跑了上来，拍拍你的肩膀|一件暗器从你背后飞来|竟见到一只灰点信鸽飞至身旁，你赶紧|只见一位同门装束的弟子满头大汗地跑了过来|忽然发现不远处的地上一块石头上刻着些什么|一位同门装束的弟子追了上来|一只白鸽飞了过来，落在你肩头)","masterquest","mqletterattive")
	addtri("block_onnpc","^(> )*(.*)(喝道：这位.*休走！|上前挡住你，朗声说道：这位|喝道：“威……武……。”|挡住了你：|伸手拦住你白眼一翻说道：千年以来|拦住你|迈步挡在你身前，双手合什说道：|大声喝道：他奶奶的，你要干嘛？|拦住你道：没有王爷的吩咐，谁也不能进去。|挡住你|一把抓住了你，说道：“咱们这里是有规矩的地方，不准带武器进入。”飞身挡住你的去路，脸上一丝表情也没有！|扭身挡住，脸上没有一点笑容！|笑嘻嘻地挡住你的去路：再玩玩才走啦。气得你半死！|一把拦住你：瞎窜什么，过来吧你给我！|一把拦住你：要上楼，先过了我这关！|哈哈一笑：这里还没打过呢，就想上楼|俏眼一瞪：没看见本姑娘在这里吗？|大喝一声：哪里走？滚下来！|冷哼一声：想走？放着十二郎在这你就给我留下来！|大吼一声：我有九条命，你有几条？放马过来！|大吼一声，执鞭拦在楼梯口！|长刀一摆，挡住你的去路，一言不发！)","system","block_onnpc")
	addtri("mqlettercontent","^(> )*“字谕弟子(.*?)：(得闻恶贼|武林人士|得闻所谓大侠)(.*?)(屡次和我派作对|打家劫舍|所为甚是讨厌)(.*)\\n(.*)出没，正是大好机会将他除去","mqletter","mqlettercontent")
	SetTriggerOption("mqlettercontent","multi_line","1")
	SetTriggerOption("mqlettercontent","lines_to_match","2")
	AddAlias("alias_start","start","",flag_base_enable,"alias_start")
	addtri("mqletterquest","^(> )*洪七公吩咐你在(.*)之前割下(.*)的人头，回(.*)交差。\\n据说此人前不久曾经在(.*)出没。","mqletterquest","mqletterquest")
	SetTriggerOption("mqletterquest","multi_line","1")
	SetTriggerOption("mqletterquest","lines_to_match","2")
	addtri("mqquestnum","^师长交给你的任务，你已经连续完成了\\s*(\\d*)\\s*个。","mqquestnum","mqquestnum")
	addtri("mqlettertimeout","^(> )*你(皱了皱眉，道：“我还是不去了，你让师傅|摇了摇头，将信函随手一撕。)","masterquest","mqlettertimeout")
	addtri("unwield","^(> )*练.*必须空手。","system","on_unwield")
	addtri("kanbush","^(> )*不用武器恐怕不行吧","system","kanbush")
	addtri("walk_gwriver","^(> )*(你看着奔腾不息的白河，心里有点紧张，不敢乱来。|船厂里走出一个船夫，瞪着眼看着你|船夫在旁边拿眼瞪着你看)","system","gwriver")
	addtri("mqletterflee","^(不好了，(.*)在|你刚想离开，突然(.*)喊道)","mqletterquest","letterflee")
	addtri("giftbaoguofail","^(> )*包裹里面的东西实在是太多了，你先好好整理整理吧。","giftbaoguofail","giftbaoguofail")
	addtri("enterchatfail","^(> )*(没有这个聊天室。|人家不欢迎你，你还是别去扫兴了。)","enterchatfail","dropgift_enterchatfail")
	addtri("mudvar_chatroom","^chatroom\\s*=\\s*(.+)","mudvar","mudvar_chatroom")
	addtri("mqhelper1","^(> )*bao(大声喝道：“好一个|忽然撮舌吹哨，你听了不禁微微一愣。|一声长啸，声音绵泊不绝，远远的传了开去。)","masterquestkill","mqhelper1")
	addtri("mqhelper","^(> )*说时迟，那时快！突然转出(.*)个人，一起冲上前来，看来是早有防备！$","mqhelper","mqhelper")
	addtri("l_2369","^    这是一片空地，四周都是乱石，杂草丛生。北边是一间小屋。南","locate","on_locate")
	addtri("l_1733","^    这是一片茂密的青竹林，一走进来，你仿佛迷失了方向。","locate","on_locate")
	addtri("on_partyhelp","^(> )*【(明教|天地会)】.{2,8}\\[(.*)\\]：helllua-help-(.*)-(.*)","masterquest","on_partyhelp")
	addtri("on_partyfind","^(> )*【(明教|天地会)】.{2,8}\\[(.*)\\]：helllua.find-(|)-(.*)-(.*)-(.*)","masterquest","on_partyfind")
	SetTriggerOption("jiqu_fail","group","system")
	addtri("status_onhptihui","^(【 平 和 】|【 愤 怒 】)\\s*(.*?)\\s*【 体 会 】(.*)$","hp","status_onhptihui")
	addtri("study_fail","^(> )*(你今天太累了，结果什么也没有研究成。|然而你今天太累了|也许是缺乏实战经验|你要向谁求教？|你的.*火候不够|你的.*水平有限|这项技能你的程度已经不输你师父了。|这项技能你恐怕必须找别人学了|[^a-zA-Z0-9、 ()【】.。,，:：;；?？!！]+说：嗯.... 你的.*功力已经是非同凡响了，我就不再教你，你自己多研究吧。|你对.*的掌握程度还未到研究的程度。)","study","study_fail")
	SetOption("wrap_column",400)
	addvar("fightcuff","")
	addvar("jinlimin","0")
	addtri("status_onrank","^(> )*你现在的江湖头衔：(.*)","rank","status_onrank")
	addtri("status_onname","^(> )*rank.*( |」)((..){1,4})\\(\\w+\\)$","charinfo","status_onname")
	addtri("mqinfosl","^(最近)(.*)(在)(.*)作恶多端，你去把他除了，提头来见。”","mqinfo","mqinfo")
	addtri("systemlogdelay","^你不能在 .* 秒钟之内连续重新连线。","system","logdelay")
	addtri("npc_killme","^(> )*(.{1,8})(一见到你|和你一碰面|对著你大喝：「可恶|喝道：「你|一眼瞥见你|和你仇人相见分外眼红)","system","npc_killme")
	addtri("walk_busy","^(> )*(你的动作还没有完成，不能移动|你逃跑失败|你被拦住了去路|你突然发现眼前的景象有些迷乱|你太累了，还是休息一会儿吧|你的内力不够，还是休息一下再说吧|这里没有这样东西可骑|现在白雕正忙着)","system","walk_on_busy")
	addtri("l_1673","^    这里是六和塔的底层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2298","^    这里是六和塔的二层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2299","^    这里是六和塔的三层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2300","^    这里是六和塔的四层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2301","^    这里是六和塔的五层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2302","^    这里是六和塔的六层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2303","^    这里是六和塔的七层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2304","^    这里是六和塔的八层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2305","^    这里是六和塔的九层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")

--	SetTriggerOption(triname,"group",trigroup)
end


if mclversion<version then
	updateversion()
	print("版本升级完成")
	SetVariable("version",tostring(version))
	inittri()
end
