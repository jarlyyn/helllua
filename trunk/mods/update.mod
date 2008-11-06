version=10
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

updateversion=function()
	print("升级mcl文件")
	addtri("remote","^(> )*[^~].{1,7}\\((.*)\\)告诉你：do (.+)","system","remote_called")
	addtri("cantell",'^can_tell\\s*"(.+)"',"mudvar","mudvar_teller")
	addtri("mqletter","^(> )*(突然一位|忽听“嗖”的一声|你转身一看|你一回头|你正欲离开|只见你刚想离开|只听扑倏扑倏几声)(.*)(弟子急急忙忙地跑了上来，拍拍你的肩膀|一件暗器从你背后飞来|竟见到一只灰点信鸽飞至身旁，你赶紧|只见一位同门装束的弟子满头大汗地跑了过来|忽然发现不远处的地上一块石头上刻着些什么|一位同门装束的弟子追了上来|一只白鸽飞了过来，落在你肩头)","masterquest","mqletterattive")
	addtri("block_onnpc","^(> )*(.*)(喝道：这位.*休走！|上前挡住你，朗声说道：这位|喝道：“威……武……。”|挡住了你：|伸手拦住你白眼一翻说道：千年以来|拦住你|迈步挡在你身前，双手合什说道：|大声喝道：他奶奶的，你要干嘛？|拦住你道：没有王爷的吩咐，谁也不能进去。|挡住你)","system","block_onnpc")
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
	addtri("walk_gwriver","	^(> )*(你看着奔腾不息的白河，心里有点紧张，不敢乱来。|船厂里走出一个船夫，瞪着眼看着你|船夫在旁边拿眼瞪着你看)","system","gwriver")
	addtri("mqletterflee","^(不好了，(.*)在|你刚想离开，突然(.*)喊道)","mqletterquest","letterflee")
	addtri("giftbaoguofail","^(> )*包裹里面的东西实在是太多了，你先好好整理整理吧。","giftbaoguofail","giftbaoguofail")
	addtri("enterchatfail","^(> )*(没有这个聊天室。|人家不欢迎你，你还是别去扫兴了。)","enterchatfail","dropgift_enterchatfail")
	addtri("mudvar_chatroom","^chatroom\\s*=\\s*(.+)","mudvar","mudvar_chatroom")
end


if mclversion<version then
	updateversion()
	print("版本升级完成")
	SetVariable("version",tostring(version))
	inittri()
end
