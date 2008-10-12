convpathlist=function(start,_path)
--把以;分隔的列表转换为机器可用的格式.第一个参数是开始位置,第二个是列表
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
