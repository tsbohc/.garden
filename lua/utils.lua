require('vimp')
api = vim.api
g = vim.g
b = vim.b
v = vim.v
fn = vim.fn
cmd = vim.cmd
G = { }
V = {
	exec = function(command)
		return vim.api.nvim_command(command)
	end,
	norm = function(command)
		return vim.api.nvim_command('norm! ' .. command)
	end,
	capture = function(command)
		return vim.api.nvim_exec(command, true)
	end,
	eval = function(string)
		return vim.api.nvim_eval(string)
	end,
	mode = function()
		return vim.fn.mode()
	end,
	colorscheme = function(name)
		return vim.api.nvim_command('colorscheme ' .. name)
	end,
	redrawstatus = function()
		vim.wo.statusline = statusline(vim.fn.bufnr())
	end
}
__autocmds = { }
V.exec('augroup ___autocmds')
V.exec('augroup END')
V.exec('autocmd! ___autocmds')
V.au = function(event, pattern, command)
	if type(command) ~= 'string' and type(command) ~= 'function' then
		return
	end
	V.exec('augroup ___autocmds')
	if type(command) == 'function' then
		local id = #__autocmds + 1
		__autocmds[id] = command
		if type(event) == 'string' then
			V.exec('autocmd ' .. event .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()')
		elseif type(event) == 'table' then
			for _, e in ipairs(event) do
				V.exec('autocmd ' .. e .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()')
			end
		end
	elseif type(command) == 'string' then
		if type(event) == 'string' then
			V.exec('autocmd ' .. event .. ' ' .. pattern .. ' ' .. command)
		elseif type(event) == 'table' then
			for _, e in ipairs(event) do
				V.exec('autocmd ' .. e .. ' ' .. pattern .. ' ' .. command)
			end
		end
	end
	return V.exec('augroup END')
end
V.map = setmetatable({
	n = function(...)
		return vimp.bind('n', ...)
	end,
	v = function(...)
		return vimp.bind('v', ...)
	end,
	s = function(...)
		return vimp.bind('s', ...)
	end,
	x = function(...)
		return vimp.bind('x', ...)
	end,
	o = function(...)
		return vimp.bind('o', ...)
	end,
	i = function(...)
		return vimp.bind('i', ...)
	end,
	c = function(...)
		return vimp.bind('c', ...)
	end
}, {
	__call = function(self, ...)
		return vimp.bind(...)
	end
})
V.getundotime = function(action)
	local time = {
		second = 1,
		minute = 60,
		hour = 60 * 60,
		day = 24 * 60 * 60,
		week = 7 * 24 * 60 * 60,
		month = 30.5 * 24 * 60 * 60,
		year = 365 * 24 * 60 * 60
	}
	local undotree = vim.fn.undotree()
	local get_undo_time
	get_undo_time = function(seq)
		local idx = seq
		for _, entry in pairs(undotree.entries) do
			if entry.seq == idx then
				return entry.time
			end
		end
		return vim.fn.localtime()
	end
	local plural = ''
	local d = vim.fn.localtime() - get_undo_time(undotree.seq_cur)
	local w = false
	if undotree.seq_cur == undotree.seq_last then
		return 'now'
	end
	if d <= time.second then
		return 'moments ago'
	elseif d < time.minute then
		return d .. ' seconds ago'
	elseif d < time.hour then
		w = 'minute'
	elseif d < time.day then
		w = 'hour'
	elseif d < time.week then
		w = 'day'
	elseif d < time.month then
		w = 'week'
	elseif d < time.year then
		w = 'month'
	else
		return 'more than a year ago'
	end
	if w then
		local n = math.floor(d / time[w])
		if n > 1 then
			plural = 's'
		else
			plural = ''
		end
		return n .. ' ' .. w .. plural .. ' ago'
	end
end
b.undotime = V.getundotime()
os.capture = function(command, raw)
	local f = assert(io.popen(command, 'r'))
	io.input(f)
	local s = assert(io.read('*a'))
	io.close(f)
	if raw then
		return s
	end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end
