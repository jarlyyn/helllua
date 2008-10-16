skilllistre=rex.new("^(?<skill>.+?)(\\((?<study>[[:alpha:]]+){0,1}(-{0,1}(?<npc>[[:alpha:]]+\\s+[[:alpha:]]+)){0,1}(-{0,1}(?<npcname>[^a-zA-Z1-9 ]+)){0,1}(-{0,1}(?<loc>\\d+)){0,1}\\)){0,1}$")
getskill=function(str)
	_tskill={}
	s,e,t=skilllist:match(str)
	return t
end