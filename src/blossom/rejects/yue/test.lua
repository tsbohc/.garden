inspect = require("inspect")
_L = {
	varsets = { }
}
local get
get = function(node_path)
	local v = _G
	for w in {
		node_path = gmatch("[%w_]+")
	} do
		if v == nil then
			return nil
		else
			v = v[w]
		end
	end
	return v
end
local withOpen
withOpen = function(path, mode, fn)
	local file = io.open(path, mode)
	fn(file)
	return file:close()
end
local loadVarset
loadVarset = function(name)
	if _L.varsets[name] == nil then
		_L.varsets[name] = { }
		local varset = _L.varsets
		return withOpen(function(file)
			for line in {
				file = lines()
			} do
				print(line)
			end
		end)
	end
end
a = {
	woo = 42
}
return print(get("a.woo"))
