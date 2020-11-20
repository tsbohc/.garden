local m = setmetatable({ }, {
	__index = function(self, k)
		return k
	end
})
local StatusLine
do
	local _class_0
	local _base_0 = {
		add = function(self, id, m)
			if type(m) == 'string' then
				self.modules[id] = true
				vim.b[id] = m
			elseif type(m) == 'table' then
				self.modules[id] = m.f
				if type(m.e) == 'string' then
					if not self.events[m.e] then
						self.events[m.e] = true
					end
				elseif type(m.e) == 'table' then
					for _, k in ipairs(m.e) do
						if not self.events[k] then
							self.events[k] = true
						end
					end
				end
				return V.au(m.e, '*', function()
					local res = self.modules[id]()
					if res then
						vim.b[id] = res
					else
						vim.b[id] = ''
					end
				end)
			end
		end,
		redraw = function(self)
			local res = ''
			for _, k in pairs(self.line) do
				if type(k) == 'string' and self.modules[k] then
					if vim.b[k] then
						res = res .. vim.b[k]
					end
				else
					res = res .. k
				end
			end
			vim.wo.statusline = res
		end
	}
	_base_0.__index = _base_0
	_class_0 = setmetatable({
		__init = function(self, line, definitions)
			self.modules = { }
			self.events = { }
			self.line = line
			for id, m in pairs(definitions) do
				if true then
					self:add(id, m)
				end
			end
			local _e = { }
			for k, v in pairs(self.events) do
				table.insert(_e, k)
			end
			return V.au(_e, '*', function()
				return self:redraw()
			end)
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
local _ = ' '
local h1 = '%#CursorLine#'
local h2 = '%#LineNr#'
local h3 = '%#Search#'
local statusline = {
	h1,
	m.lines,
	_,
	m.fname,
	_,
	h2,
	_,
	m.undotime,
	m.saved,
	_,
	h3,
	m.readonly,
	h2,
	_,
	'%=%<',
	m.cwd,
	_,
	h1,
	_,
	m.layout,
	m.percentage,
	_,
	h2
}
local modules = {
	['test'] = {
		e = 'CursorMoved',
		f = function()
			return vim.fn.localtime()
		end
	},
	['fname'] = {
		e = {
			'BufEnter',
			'BufWritePost'
		},
		f = function()
			local name = fn.expand('%:t')
			if name ~= '' then
				return '‹‹ ' .. name .. ' ››'
			end
		end
	},
	['ft'] = {
		e = {
			'BufEnter',
			'BufWritePost'
		},
		f = function()
			return vim.bo.filetype
		end
	},
	['cwd'] = {
		e = {
			'BufEnter',
			'BufWritePost'
		},
		f = function()
			return fn.expand('%:p:~:h')
		end
	},
	['saved'] = {
		e = {
			'User UndoRedo',
			'BufEnter',
			'BufWritePost'
		},
		f = function()
			local name = fn.expand('%:t')
			if name ~= '' then
				return [[%{&modified?'':',, saved'}]]
			end
		end
	},
	['layout'] = {
		e = {
			'InsertEnter',
			'InsertLeave'
		},
		f = function()
			if G.previous_layout == 'ru' then
				return 'ru '
			end
		end
	},
	['undotime'] = {
		e = {
			'User UndoRedo',
			'BufEnter',
			'BufLeave',
			'FocusLost',
			'FocusGained',
			'BufWritePost'
		},
		f = V.getundotime
	},
	['readonly'] = {
		e = 'BufEnter',
		f = function()
			return [[%{&readonly?' readonly ':''}]]
		end
	},
	['lines'] = '%L',
	['percentage'] = '%2p%%'
}
return StatusLine(statusline, modules)
