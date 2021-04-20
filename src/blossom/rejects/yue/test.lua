inspect = require("inspect")
M = { }
config = "~/.config/"
local Module
do
	local _class_0
	local _base_0 = {
		link = function(self, f, t)
			self.source = f
			self.target = t
		end,
		inject = function(self, ...)
			for _, item in ipairs({
				...
			}) do
				table.insert(self.varsets, item)
			end
		end,
		register = function(self)
			M[self.name] = self
		end
	}
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self, name)
			self.varsets = { }
			self.name = name
			return self:register()
		end,
		__base = _base_0,
		__name = "Module"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({}, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Module = _class_0
end
local font_size = 10
local colo = "kohi"
wrap(alacritty:link("alacritty.yml", config .. "alacritty/alacritty.yml"):inject("test", {
	font_size = font_size
}, colo))
print(inspect(M.alacritty.varsets))
return
