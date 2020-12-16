do
	local _class_0
	local _base_0 = { }
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self, callback)
			return setmetatable(self, {
				__index = function(self, index)
					self[index] = function(...)
						return callback(index, ...)
					end
					return rawget(self, index)
				end
			})
		end,
		__base = _base_0,
		__name = "IndexAsMethod"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({}, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	IndexAsMethod = _class_0
end
