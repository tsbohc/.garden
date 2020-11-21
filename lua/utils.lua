require('vimp')
uuu = 'unset'
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
		vim.wo.statusline = statusline()
	end
}
__autocmds = { }
V.exec('augroup ___autocmds')
V.exec('augroup END')
V.exec('autocmd! ___autocmds')
flatten = function(t)
	local n = #t
	local res = ''
	for i, v in ipairs(t) do
		res = res .. v
		if i < n then
			res = res .. ','
		end
	end
	return res
end
check_for_user_events = function(e)
	if type(e) == 'string' then
		if e:match('User ') then
			return true
		end
	elseif type(e) == 'table' then
		for _, k in pairs(e) do
			if k:match('User ') then
				return true
			end
		end
	end
	return false
end
V.au = function(events, pattern, action)
	if type(action) ~= 'string' and type(action) ~= 'function' then
		return
	end
	local debug = false
	if type(action) == 'function' then
		local id = #__autocmds + 1
		__autocmds[id] = action
		action = ':lua __autocmds[' .. id .. ']()'
	end
	V.exec('augroup ___autocmds')
	if check_for_user_events(events) then
		if type(events) == 'string' then
			pattern = ''
		elseif type(events) == 'table' then
			for i, k in pairs(events) do
				if k:match('User ') then
					V.exec('autocmd ' .. k .. ' ' .. action)
					if debug then
						print('autocmd ' .. k .. ' ' .. action)
					end
					table.remove(events, i)
				end
			end
		end
	end
	if type(events) == 'table' then
		if #events == 0 then
			return
		end
		events = flatten(events)
	end
	V.exec('autocmd ' .. events .. ' ' .. pattern .. ' ' .. action)
	if debug then
		print('autocmd ' .. events .. ' ' .. pattern .. ' ' .. action)
	end
	V.exec('augroup END')
	if debug then
		return print(' ')
	end
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
file_exists = function(name)
	local f = io.open(name, 'r')
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end
V.getundotime = function()
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
	local d = 0
	local fname = vim.fn.expand('%:p')
	if undotree.seq_cur == undotree.seq_last and fname ~= '' then
		local modi = tonumber(os.capture('stat -c %Y ' .. fname))
		if modi then
			local d1 = vim.fn.localtime() - modi
			local d2 = vim.fn.localtime() - get_undo_time(undotree.seq_cur)
			if d1 < d2 then
				d = d2
			else
				d = d1
			end
		else
			return 'unsaved'
		end
	elseif fname == '' then
		return 'unsaved'
	else
		d = vim.fn.localtime() - get_undo_time(undotree.seq_cur)
	end
	local plural = ''
	local w = false
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
