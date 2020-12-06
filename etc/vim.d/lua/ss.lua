local __statusline = { }
do
	local _class_0
	local _base_0 = {
		init = function(self)
			local all_events = { }
			for k, v in pairs(self.events) do
				table.insert(all_events, k)
			end
			table.insert(all_events, 'BufReadPost')
			return V.au(all_events, '*', self.redraw)
		end,
		redraw = function(self)
			local bufnr = vim.fn.bufnr()
			local cache = __statusline[bufnr]
			if cache == nil then
				vim.wo.statusline = 'no cache for bufnr ' .. bufnr
				return
			end
			local res = ''
			for _, k in ipairs(cache) do
				res = res .. k
			end
			vim.wo.statusline = res
		end,
		save_cache = function(self, i, value)
			local bufnr = vim.fn.bufnr()
			if not __statusline[bufnr] then
				__statusline[bufnr] = { }
			end
			local cache = __statusline[bufnr]
			if value ~= nil then
				cache[i] = value
			else
				cache[i] = ''
			end
		end,
		unpack_events = function(self, event_string)
			assert(type(event_string) == 'string', 'unpack_events: expected type string, got ' .. type(event_string))
			event_string = event_string .. ','
			local _accum_0 = { }
			local _len_0 = 1
			for e in event_string:gmatch("([^,]+),%s*") do
				_accum_0[_len_0] = e
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end
	}
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self, generator)
			self.actions = { }
			self.events = { }
			for i, mod in ipairs(generator) do
				if type(mod) == 'string' then
					V.au('BufEnter', '*', function()
						return self:save_cache(i, mod)
					end)
				elseif type(mod) == 'table' then
					local events, action = mod[1], mod[2]
					local event_table = self:unpack_events(events)
					table.insert(event_table, 'BufEnter')
					for _, k in ipairs(event_table) do
						self.events[k] = true
					end
					V.au(event_table, '*', function()
						return self:save_cache(i, action())
					end)
				end
			end
			return self:init()
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
