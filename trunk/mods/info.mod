info={}
info.fail=2
info.retry=1
info.answer=3
askinfo=function(npc,content)
	info.answer=3
	if infolist[npc]~=nil then
		setinfoname(infolist[npc]["name"])
		catch("info","ask "..infolist[npc]["id"].." about "..content)
	end

end

setinfoname=function(str)
	SetTriggerOption ("info_fail", "match", "^(> )*("..str..")(摇摇头，说道：没听说过。|疑惑地看着你，摇了摇头。|睁大眼睛望着你，显然不知道你在说什么。|耸了耸肩，很抱歉地说：无可奉告。|说道：嗯....这我可不清楚，你最好问问别人吧。|想了一会儿，说道：对不起，你问的事我实在没有印象。)")
	SetTriggerOption ("info_retry", "match", "^(> )*("..str..")说道：(阿嚏！有点感冒，不好意思。|等...等等，你说什么？没听清楚。|嗯，稍等啊，就好... 好了，你刚才说啥？|这个... 这个... 哦，好了，啊？你问我呢？|唉呦！... 不好意思，是你问我么？|就好... 就好... 好了，你说啥？|你干啥？没看我忙着呢么？|!)")
end

info_fail=function()
	info.answer=info.fail
end

info_retry=function()
	info.answer=info.retry
end

