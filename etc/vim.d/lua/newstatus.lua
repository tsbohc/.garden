local _ = ' '
local m = setmetatable({ }, {
	__index = function(self, k)
		return k
	end
})
local StatusLine
do
	local _class_0
	local _base_0 = {
		ine = function(self, l)
			self.line = l
		end,
		add = function(self, id, events, action)
			self.modules[id] = {
				e = events,
				a = action
			}
		end,
		process = function(self, id, events, action)
			self.actions[id] = action
			self:keep_events(events)
			return V.au(events, '*', function()
				local res = self.actions[id]()
				if res then
					vim.b[id] = res
				else
					vim.b[id] = ''
				end
			end)
		end,
		keep_events = function(self, events)
			if type(events) == 'string' then
				self.events[events] = true
			elseif type(events) == 'table' then
				for _, k in ipairs(events) do
					self.events[k] = true
				end
			end
		end,
		set = function(self)
			for id, m in pairs(self.modules) do
				self:process(id, m.e, m.a)
			end
			local _e = { }
			for k, v in pairs(self.events) do
				table.insert(_e, k)
			end
			return V.au(_e, '*', function()
				local res = ''
				for _, k in pairs(self.line) do
					if type(k) == 'string' and self.actions[k] then
						if vim.b[k] then
							res = res .. vim.b[k]
						end
					else
						res = res .. k
					end
				end
				vim.wo.statusline = res
			end)
		end
	}
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self)
			self.line = { }
			self.actions = { }
			self.events = { }
			self.modules = { }
		end,
		__base = _base_0,
		__name = "StatusLine"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({}, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	StatusLine = _class_0
end
L = StatusLine
L:add('CursorMoved', function()
	return vim.fn.localtime()
end)
L:add('%=')
L:add('arstarst')
return StatusLine({
	'stringy'
})
