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
	SetTriggerOption ("info_fail", "match", "^(> )*("..str..")(ҡҡͷ��˵����û��˵����|�ɻ�ؿ����㣬ҡ��ҡͷ��|�����۾������㣬��Ȼ��֪������˵ʲô��|�����ʼ磬�ܱ�Ǹ��˵���޿ɷ�档|˵������....���ҿɲ��������������ʱ��˰ɡ�|����һ�����˵�����Բ������ʵ�����ʵ��û��ӡ��)")
	SetTriggerOption ("info_retry", "match", "^(> )*("..str..")˵����(���磡�е��ð��������˼��|��...�ȵȣ���˵ʲô��û�������|�ţ��ԵȰ����ͺ�... ���ˣ���ղ�˵ɶ��|���... ���... Ŷ�����ˣ������������أ�|���ϣ�... ������˼����������ô��|�ͺ�... �ͺ�... ���ˣ���˵ɶ��|���ɶ��û����æ����ô��|!)")
end

info_fail=function()
	info.answer=info.fail
end

info_retry=function()
	info.answer=info.retry
end

