local V = { }
V.ft = setmetatable({
	iscode = function()
		return print
	end,
	istext = function()
		return print
	end
}, {
	__call = function(self, filetype)
		return print(filetype)
	end
})
V.log = function(message)
	return print(message)
end
return V
