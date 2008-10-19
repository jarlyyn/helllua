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

newmod=function(modname)
	output=modname.."={}\r\n"
	output=output..modname..'["ok"]=nil\r\n'
	output=output..modname..'["fail"]=nil\r\n\r\n'
	output=output.."do_"..modname.."=function("..modname.."_ok,"..modname.."_fail)\r\n"
	output=output.."	"..modname..'["ok"]='..modname.."_ok\r\n"
	output=output.."	"..modname..'["fail"]='..modname.."_fail\r\n"
	output=output.."end\r\n\r\n"
	output=output..modname..'["end"]=function(s)\r\n'
	output=output..'	if ((s~="")and(s~=nil)) then\r\n'
	output=output.."		call("..modname.."[s])\r\n"
	output=output.."	end\r\n"
	output=output.."	"..modname..'["ok"]=nil\r\n'
	output=output.."	"..modname..'["fail"]=nil\r\n'
	output=output.."end\r\n\r\n"
	output=output..modname.."_end_ok=function()\r\n"
	output=output.."	"..modname..'["end"]("ok")\r\n'
	output=output.."end\r\n\r\n"
	output=output..modname.."_end_fail=function()\r\n"
	output=output.."	"..modname..'["end"]("fail")\r\n'
	output=output.."end\r\n\r\n"
	SendToNotepad(modname,output)
end