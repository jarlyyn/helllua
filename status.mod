checkstatus=function()
run("special;who -n -fam;score;league;")
end

status_on_score1=function (name, line, wildcards)
	print(wildcards[2])
	print(wildcards[3])
end

status_on_score3=function (name, line, wildcards)
	print(wildcards[1])
	print(wildcards[2])
end

status_on_teacher=function (name, line, wildcards)
	print(wildcards[1])
end
status_noteacher=function (name, line, wildcards)
	print("no teacher")
end