print("�������ģ��")
assert  (package.loadlib (luapath.."aeslib.dll","luaopen_aes")) ()
encrypt=function(text,key)
	return utils.base64encode(aes.encrypt(text,key))
end

decrypt=function(text,key)
	return aes.decrypt(utils.base64decode(text),key)
end