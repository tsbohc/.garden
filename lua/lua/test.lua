local A = { }
setmetatable(A, {
	__index = function(self, k)
		return k
	end,
	__newindex = function(self, k, v)
		return print('new', k, v)
	end,
	__call = function(self, val)
		if type(val) == 'string' then
			return print('cal', val)
		else
			for k, v in pairs(val) do
				print(k, v)
			end
		end
	end
})
local set
set = function(k, v)
	return print('set', k, type(v))
end
local print = print
setfenv(1, A)
A(noshowmode)
A({
	synmaxcol = 256
})
return
