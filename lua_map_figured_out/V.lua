local V = { }
V.ft = setmetatable({
	iscode = function()
		return print
	end,
	istext = function()
		if vim.bo.filetype == 'python' then
			return false
		else
			return true
		end
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
