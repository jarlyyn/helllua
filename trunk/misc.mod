convpathlist=function(start,_path)
--����;�ָ����б�ת��Ϊ�������õĸ�ʽ.��һ�������ǿ�ʼλ��,�ڶ������б�
	output="={"
	re=rex.new("([^;]+)")
	n=re:gmatch(_path,function (m, t)
		output=output..('({loc='..tostring(start)..',step="'..m..'"}),')
		start=getexitroom(start,m)
	end)
	output=output.."}"
SendToNotepad("pathlist",output)
end

gopath=function(path)
	do_steppath(path,steppath["next"])
end
