version=101
mclversion=tonumber(GetVariable("version"))

if mclversion==nil then
	mclversion=0
end

addtri=function(triname,trimatch,trigroup,triscript)
	AddTriggerEx(triname, trimatch, "", flag_base, -1, 0, "",  triscript, 0, 100)
	SetTriggerOption(triname,"group",trigroup)
end

deltri=function(triname)
	DeleteTrigger(triname)
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
	addtri("canaccept",'^can_accept\\s*"(.+)"',"mudvar","mudvar_canaccept")
	addtri("mqletter","^(> )*(突然一位|忽听“嗖”的一声|你转身一看|你一回头|你正欲离开|只见你刚想离开|只听扑倏扑倏几声)(.*)(弟子急急忙忙地跑了上来，拍拍你的肩膀|一件暗器从你背后飞来|竟见到一只灰点信鸽飞至身旁，你赶紧|只见一位同门装束的弟子满头大汗地跑了过来|忽然发现不远处的地上一块石头上刻着些什么|一位同门装束的弟子追了上来|一只白鸽飞了过来，落在你肩头)","masterquest","mqletterattive")
	addtri("block_onnpc","^(> )*(.*)(喝道：这位.*休走！|上前挡住你，朗声说道：这位|喝道：“威……武……。”|挡住了你：|伸手拦住你白眼一翻说道：千年以来|拦住你|迈步挡在你身前，双手合什说道：|大声喝道：他奶奶的，你要干嘛？|拦住你道：没有王爷的吩咐，谁也不能进去。|挡住你|一把抓住了你，说道：“咱们这里是有规矩的地方，不准带武器进入。”飞身挡住你的去路，脸上一丝表情也没有！|扭身挡住，脸上没有一点笑容！|笑嘻嘻地挡住你的去路：再玩玩才走啦。气得你半死！|一把拦住你：瞎窜什么，过来吧你给我！|一把拦住你：要上楼，先过了我这关！|哈哈一笑：这里还没打过呢，就想上楼|俏眼一瞪：没看见本姑娘在这里吗？|大喝一声：哪里走？滚下来！|冷哼一声：想走？放着十二郎在这你就给我留下来！|大吼一声：我有九条命，你有几条？放马过来！|大吼一声，执鞭拦在楼梯口！|长刀一摆，挡住你的去路，一言不发！|吹着白胡子，挡在楼梯口|用冷森森的眼光扫了你一眼，你迈向楼梯的脚吓了一哆嗦|长剑电闪，一下就刺到了楼梯口)","system","block_onnpc")
	addtri("mqlettercontent","^(> )*“字谕弟子(.*?)：(得闻恶贼|武林人士|得闻所谓大侠)(.*?)(屡次和我派作对|打家劫舍|所为甚是讨厌)(.*)\\n(.*)出没，正是大好机会将他除去","mqletter","mqlettercontent")
	SetTriggerOption("mqlettercontent","multi_line","1")
	SetTriggerOption("mqlettercontent","lines_to_match","2")
	AddAlias("alias_start","^start\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_start")
	AddAlias("alias_kill","^#kill\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_kill")
	AddAlias("alias_make","^#make\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_make")
	AddAlias("alias_re","^#re(\\s(.*)){0,1}$","",flag_base_enable+alias_flag.RegularExpression,"alias_re")
	AddAlias("alias_pick","^#pick$","",flag_base_enable+alias_flag.RegularExpression,"alias_pick")
	AddAlias("alias_setvalue","^#set(\\s{0,1}(\\S*)){0,1}\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_setvalue")
	AddAlias("alias_check","^#check\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_check")
	AddAlias("alias_lian","^#lian\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_lian")
	AddAlias("alias_assist","^#assist( (.+)){0,1}$","",flag_base_enable+alias_flag.RegularExpression,"alias_assist")
	AddAlias("alias_dazuoneili","^#dazuo\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_dazuoneili")
	AddAlias("alias_beiqi","^#beiqi\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_beiqi")
	AddAlias("alias_letter","^#letter\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_letter")
	AddAlias("alias_caxie","^#caxie\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_caxie")
	AddAlias("alias_fish","^#fish\\s{0,1}(.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_fish")
	AddAlias("alias_dutable","#dutable","",flag_base_enable,"alias_dutable")
	AddAlias("alias_to","^#to (.*)$","",flag_base_enable+alias_flag.RegularExpression,"alias_to")
	AddAlias("alias_do","^##(.+)$","",flag_base_enable+alias_flag.RegularExpression,"alias_do")
	AddAlias("alias_canwu","#canwu","",flag_base_enable,"alias_canwu")
	addtri("mqletterquest","^(> )*洪七公吩咐你在(.*)之前割下(.*)的人头，回(.*)交差。\\n据说此人前不久曾经在(.*)出没。","mqletterquest","mqletterquest")
	SetTriggerOption("mqletterquest","multi_line","1")
	SetTriggerOption("mqletterquest","lines_to_match","2")
	addtri("mqquestnum","^师长交给你的任务，你已经连续完成了\\s*(\\d*)\\s*个。","mqquestnum","mqquestnum")
	addtri("mqlettertimeout","^(> )*你(皱了皱眉，道：“我还是不去了，你让师傅|摇了摇头，将信函随手一撕。)","masterquest","mqlettertimeout")
	addtri("unwield","^(> )*练.*必须空手。","system","on_unwield")
	addtri("sell_broken","^(> )*唐楠随手一扔，道：(.*)一文不值！","system","sell_broken")
	addtri("pick_full","^(> )*((.*)对你而言太重了。|你身上的东西实在是太多了，没法再拿东西了。)","pick","pick_full")
	addtri("walk_boatout","^(> )*(少女说: “到啦，上岸吧。”，随即一点竹篙，把舟泊好。|艄公说“到啦，上岸吧”，随即把一块踏脚板搭上堤岸。)","system","on_boatout")
	addtri("walk_taihucrossfail","^(> )*(你觉得湖面太宽，没有十足的把握跃过去。|你看着浩瀚的太湖，心里不禁打了个突，没敢乱来。|你使劲儿一蹦，离瀑布顶还有数丈远就掉了下来，摔的鼻青)","system","on_taihunocross")
	addtri("kanbush","^(> )*不用武器恐怕不行吧|要刺墙不用家伙恐怕不行吧！","system","kanbush")
	addtri("walk_gwriver","^(> )*(你觉得河面太宽，没有十足的把握跃过去。|你看着奔腾不息的白河，心里有点紧张，不敢乱来。|船厂里走出一个船夫，瞪着眼看着你|船夫在旁边拿眼瞪着你看)","system","gwriver")
	addtri("mqletterflee","^(不好了，(.*)在|你刚想离开，突然(.*)喊道)","mqletterquest","letterflee")
	addtri("giftbaoguofail","^(> )*(包裹|布袋)里面的东西实在是太多了，你先好好整理整理吧。","giftbaoguofail","giftbaoguofail")
	addtri("giftbaoguoheavy","^(> )*([^`].(..){1,7})对包裹而言太重了。","giftbaoguofail","giftbaoguoheavy")
	addtri("enterchatfail","^(> )*(没有这个聊天室。|人家不欢迎你，你还是别去扫兴了。)","enterchatfail","dropgift_enterchatfail")
	addtri("mudvar_chatroom","^chatroom\\s*=\\s*(.+)","mudvar","mudvar_chatroom")
	addtri("mudvar_eatjz","^eat9z\\s*=\\s*(.+)","mudvar","mudvar_eatjz")
	addtri("mudvar_nopowerup","^nopowerup\\s*=\\s*(.+)","mudvar","mudvar_nopowerup")
	addtri("mqhelper1","^(> )*bao(大声喝道：“好一个|忽然撮舌吹哨，你听了不禁微微一愣。|一声长啸，声音绵泊不绝，远远的传了开去。)","masterquestkill","mqhelper1")
	addtri("mqhelper","^(> )*说时迟，那时快！突然转出(.*)个人，一起冲上前来，看来是早有防备！$","mqhelper","mqhelper")
	addtri("l_2369","^    这是一片空地，四周都是乱石，杂草丛生。北边是一间小屋。南","locate","on_locate")
	addtri("l_1733","^    这是一片茂密的青竹林，一走进来，你仿佛迷失了方向。","locate","on_locate")
	addtri("l_2366","^    这里就是神龙岛了。南边是一望无际的大海；","locate","on_locate")
	addtri("on_partyhelp","^(> )*【(明教|天地会)】.{2,8}\\[(.*)\\]：helllua-help-(.*)-(.*)","masterquest","on_partyhelp")
	addtri("on_partyfind","^(> )*【(明教|天地会)】.{2,8}\\[(.*)\\]：helllua.find-(|)-(.*)-(.*)-(.*)","masterquest","on_partyfind")
	SetTriggerOption("jiqu_fail","group","system")
	addtri("status_onhptihui","^(【 平 和 】|【 愤 怒 】)\\s*(.*?)\\s*【 体 会 】(.*)$","hp","status_onhptihui")
	addtri("study_fail","^(> )*(你今天太累了，结果什么也没有研究成。|然而你今天太累了|也许是缺乏实战经验|你要向谁求教？|你的.*火候不够|你的.*水平有限|这项技能你的程度已经不输你师父了。|这项技能你恐怕必须找别人学了|[^a-zA-Z0-9、 ()【】.。,，:：;；?？!！]+说：嗯.... 你的.*功力已经是非同凡响了，我就不再教你，你自己多研究吧。|你对.*的掌握程度还未到研究的程度。)","study","study_fail")
	SetOption("wrap_column",400)
	addvar("fightcuff","")
	addvar("jinlimin","0")
	addvar("killcmd","jiqu")
	addvar("nuqimin","0")
	addvar("configfile","")
	addvar("fight_preper","")
	addvar("id","")
	addtri("status_onrank","^(> )*你现在的江湖头衔：(.*)","rank","status_onrank")
	addtri("status_onname","^(> )*rank.*( |」)((..){1,4})\\(\\w+\\)$","charinfo","status_onname")
	addtri("mqinfosl","^(最近)(.*)(在)(.*)作恶多端，你去把他除了，提头来见。”","mqinfo","mqinfo")
	addtri("systemlogdelay","^你不能在 .* 秒钟之内连续重新连线。","system","logdelay")
	addtri("npc_killme","^(> )*(.{1,8})(一见到你|和你一碰面|对著你大喝：「可恶|喝道：「你|一眼瞥见你|和你仇人相见分外眼红)","system","npc_killme")
	addtri("walk_busy","^(> )*(你的动作还没有完成，不能移动|你逃跑失败|你被拦住了去路|你突然发现眼前的景象有些迷乱|你太累了，还是休息一会儿吧|你的内力不够，还是休息一下再说吧|这里没有这样东西可骑|现在白雕正忙着|只听得湖面上隐隐传来：“就来了啦……”|只听得湖面上隐隐传来：“别急嘛，这儿正忙着呐……”)","system","walk_on_busy")
	addtri("l_1136","^    这里是少林寺前的广场，整个广场由大块的青石铺成，极为","locate","on_locate")
	addtri("l_1673","^    这里是六和塔的底层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2298","^    这里是六和塔的二层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2299","^    这里是六和塔的三层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2300","^    这里是六和塔的四层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2301","^    这里是六和塔的五层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2302","^    这里是六和塔的六层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2303","^    这里是六和塔的七层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2304","^    这里是六和塔的八层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_2305","^    这里是六和塔的九层。窗\\(window\\)外是浓妆淡抹的西子湖","locate","on_locate")
	addtri("l_26","^    这是一家价钱低廉的客栈，生意非常兴隆。外地游客多选择这里落脚，你","locate","on_locate")
	addtri("l_54","^    这是南城门，城墙被当成了广告牌，贴满了花花绿绿各行各业的广告，","locate","on_locate")
	addtri("jiqu_fail","^(> )*(你的实战经验太浅，还无法领会通过实战获得的心得。|你感觉自己的实战经验还有欠缺，还无法领会更高境界的武学修养。|你现在精神不济，难以抓住实战体会中的秘要！|你现在没有充足的体力用来吸收实战的心得。)","system","jiqu_fail")
	addtri("study_needweapon","^(> )*你必须先找一把.*才能练.*法。","study","study_needweapon")
	addtri("items_onbagsstart","^(> )*设定环境变数：no_more = \"getbag-(.+)\"$","bagitem","on_bagsstart")
	addtri("items_onbagsend","^(> )*设定环境变数：no_more = \"getbagend\"$","bagitem","on_bagsend")
	addtri("walk_maxstep","^(> )*设定环境变数：no_more = \"maxstep\"$","system","walk_maxstep")
	SetTriggerOption("walk_maxstep","omit_from_output","1")
	SetTriggerOption("items_onbagsstart","omit_from_output","1")
	SetTriggerOption("items_onbagsend","omit_from_output","1")
	addtri("items_onbagitems","^    ([^a-z!@#$%\\^&*()\\\\/.,<> ]+)\\((\\w*\\s{0,1}\\w+)\\)$","bagitem","on_bagitems")
	addtri("heal_danbusy","^(> )*你的内力不足，无法运满一个周天。$","dispel","on_dispelneilifail")
	addtri("heal_neilifail","^(> )*你刚服用过药，需药性发挥完效用以后才能继续服用。$","eatdan","on_danbusy")
	addtri("status_onhptihui","^(【 平 和 】|【 愤 怒 】)\\s*([^/ ]*).*【 体 会 】(.*)$","hp","status_onhptihui")
	addtri("on_getweapon","^(> )*你手腕一麻，手中(.*)不由脱手而出！","system","on_getweapon")
	addtri("study_gold","^(> )*(朱熹|厨娘|戚长发)(说道：您太客气了，这怎么敢当？|笑着说道：您见笑了，我这点雕虫小技怎够资格「指点」您什么？|像是受宠若惊一样，说道：请教？这怎么敢当？)","study","study_gold")
	addtri("askyouok","^(> )*游讯嘿嘿奸笑两声，对你小声道：“没有问题，不过得要50两黄金，不二价！”","askyou","askyouok")
	addtri("makeyao_buy","^(> )*你点了点药材，发现(.*)的分量还不够。","makeyao","makeyao_buy")
	addtri("makeyao_fail","^(> )*你还不会配这种药啊！","makeyao","makeyao_fail")
	addtri("makeyao_ok","^(> )*你把「%%%」成功的制好了！","makeyao","makeyao_ok")
	addtri("mqassistkill","^(> )*你对著sss喝道：","mqassistkill","mqassistkill")
	addtri("mqassister","^(> )*([^`].(..){1,3})决定帮助你一同完成任务，你是否同意\\(right\\|refuse (.+)\\)？","mqassister","mqassister")
	addtri("mqassistor","^(> )*([^`].(..){1,3})愿意接受你的帮助。","mqassistor","mqassistor")
	addtri("mqassistreport","^(> )*你告诉ssss\\(Ddddd\\)","mqassist","mqassistreport")
	addtri("mqassistnpc","^(> )*ssss\\(Ddddd\\)告诉你：npckill\\.(.*)\\.(.*)\\.(.*)","mqassistnpc","mqassistnpc")
	addtri("mqassistok","^(> )*ssss\\(Ddddd\\)告诉你：npckillok","mqassistok","mqassistok")
	addtri("walk_onnoweapon","^(> )*(张翠山道：“各色人等，到解剑岩都需解剑，千百年来概无例外！”你慑于武当山规，|王五上前挡住你，朗声说道：这位)","system","walk_onnoweapon")
	addtri("item_needfill","^(> )*你从.*那里买下了(一|二|三|四|五|六|七|八|九|十|百)+..牛皮水袋。","system","item_needfill")
	addtri("walkdogkill","^(> )*看起来(.*)想杀死你！","system","dogkill")
	addtri("system_login",'目前共有 \\d* 位巫师、\\d* 位玩家在线上，以及 \\d* 位使用者尝试连线中。',"system","system_login")
	addtri("status_testtouch","^(> )*你轻轻一弹.*，长吟道：“别来无恙乎？|你轻轻抚过.*，感慨良深，作古风一首，.*铃铃作响，似以和之。|你抓着.*，沉思良久。","testtouch","testtouch")
	addtri("missok","^(> )*你口中念念有词，转瞬天际一道长虹划过，你驾彩虹而走。","system","missok")
	addtri("walkdogkill","^(> )*看起来(.*)想杀死你！","system","dogkill")
	addtri("flyfail","^(> )*^(> )*(你已经超过17岁了，无法再使用这个指令回到客店了。|你身上带著密函，不能施展。|你要召唤什么物品？|你不知道如何召唤这个物品|你已经在扬州客店了。|你摸着.*，发了半天的呆。|你觉得.*的感觉相当飘忽，看来精力不济，难以感应。|你瞪着.*，看啥？|你摸着.*，发了半天的呆。)","system","walk_on_flyfail")
	addtri("lianrest","^(> )*(你的内力不够练.*。|你现在太累了，结果一行也没有看下去。)$","lian","lianrest")
	addtri("on_objend","^(> )+","roomobj","on_objend")
	addtri("on_drunk2","^(> )*你觉得脑中昏昏沉沉，身子轻飘飘地，大概是醉了。$","system","on_drunk2")
	addtri("on_drunk","^(> )*你觉得一阵酒意上冲，眼皮有些沉重了。$","system","on_drunk")
	addtri("dazuofull","^(> )*你的内力修为似乎已经达到了瓶颈。$","dazuoneili","dazuofull")
	addtri("lianwield","^(> )*你使用的武器不对。$","lian","lianwield")
	addtri("event_acceptrecon","^(> )*你还是把眼前的敌人放倒再说吧！$","accept","event_acceptrecon")
	addtri("event_acceptretry","^(> )*你现在正忙，等有空了再说吧！|你等会儿，在大宗师面前抢什么茬儿？$","accept","event_acceptretry")
	addtri("event_accepting","^(> )*你正在应战呢！$","accept","event_accepting")
	addtri("event_acceptname","^(> )*【东拉西扯】%1\[%2\]：(.*)少要猖狂，我来了！$","accept","event_acceptname")
	addtri("event_acceptwin","^(> )*%1身子一退，掉下(.*)！$","accept","event_acceptwin")
	addtri("on_accept","^(> )*(黄裳|南海神尼|独孤求败|葵花太监)告诉你：你何不出手应战\\(accept\\)？扬我中华武林威风！$","system","on_accept")
--	SetTriggerOption(triname,"group",trigroup)
	call(updatecmd)
end


if mclversion<version then
	updateversion()
	print("版本升级完成")
	SetVariable("version",tostring(version))
	inittri()
end
