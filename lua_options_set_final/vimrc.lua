require('utils')
require('ss')
local o = setmetatable({ }, {
	__call = function(self, options)
		for k, v in pairs(options) do
			if type(k) == 'number' then
				V.exec('set ' .. v)
			else
				V.exec('set ' .. k .. '=' .. v)
			end
		end
	end,
	__index = function(self, k)
		return api.nvim_get_option(k)
	end,
	__newindex = function(self, k, v)
		return api.nvim_set_option(k, v)
	end
})
V.colorscheme('gruvbox')
V.exec([[ highlight EndOfBuffer ctermfg=bg guifg=bg ]])
g.mapleader = ' '
local keyremap
keyremap = function(mode, data)
	for k, v in pairs(data) do
		V.map(mode, k, v)
		V.map(mode, string.upper(k), string.upper(v))
	end
end
keyremap('nvo', {
	['n'] = 'j',
	['e'] = 'k',
	['i'] = 'l',
	['l'] = 'i',
	['k'] = 'n',
	['j'] = 'f',
	['f'] = 'e'
})
V.map('<C-Space>', function()
	return print('arst')
end)
V.map.n('zC', 'zM')
V.map.n('Y', 'y$')
V.map.n(';', ':')
V.map.x('<', '<gv')
V.map.x('>', '>gv')
V.map.n({
	'silent'
}, '//', ':noh<cr>')
V.map.n({
	'silent'
}, '*', '*N')
V.map.n('<leader>r', ':%s///g<left><left>')
V.map.x('<leader>r', ':s///g<left><left>')
V.map.x('*', function()
	V.norm('gvy')
	V.exec('/' .. V.eval('@"'))
	return V.norm('<c-o>')
end)
V.map.n('u', function()
	V.exec(':silent undo')
	return V.exec(':doautocmd User UndoRedo')
end)
V.map.n('U', function()
	V.exec(':silent redo')
	return V.exec(':doautocmd User UndoRedo')
end)
V.map.n({
	'override',
	'expr'
}, 'n', function()
	if v.count > 0 then
		return 'j'
	else
		return 'gj'
	end
end)
V.map.n({
	'override',
	'expr'
}, 'e', function()
	if v.count > 0 then
		return 'k'
	else
		return 'gk'
	end
end)
V.map.n('H', '^')
V.map.n('O', '$')
V.map.v('H', '^')
V.map.v('O', '$')
V.map.o('H', '^')
V.map.o('O', '$')
V.map('nv', {
	'override'
}, 'N', '<c-d>')
V.map('nv', {
	'override'
}, 'E', '<c-u>')
V.map('nv', '<ScrollWheelUp>', '<c-y>')
V.map('nv', '<ScrollWheelDown>', '<c-e>')
V.map.n('<c-h>', '<c-w>h')
V.map.n('<c-n>', '<c-w>j')
V.map.n('<c-e>', '<c-w>k')
V.map.n('<c-i>', '<c-w>l')
V.map.n('<left>', '<c-w>h')
V.map.n('<down>', '<c-w>j')
V.map.n('<up>', '<c-w>k')
V.map.n('<right>', '<c-w>l')
V.map.i('<c-o>', 'ö')
V.map.i('<c-a>', 'ä')
V.map.i('<c-u>', 'ü')
V.map.i('<c-s>', 'ß')
local unload_lua_namespace
unload_lua_namespace = function(prefix)
	local prefix_with_dot = prefix .. '.'
	for key, value in pairs(package.loaded) do
		if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
			package.loaded[key] = nil
		end
	end
end
vimp.nnoremap('<leader>s', function()
	vimp.unmap_all()
	unload_lua_namespace('vimrc')
	unload_lua_namespace('utils')
	unload_lua_namespace('ss')
	V.exec('silent wa')
	require('vimrc')
	print('reloaded vimrc')
	return V.exec('silent noh')
end)
dump = function(...)
	local objects = vim.tbl_map(vim.inspect, {
		...
	})
	return print(unpack(objects))
end
folding = function()
	local fold_size = v.foldend - v.foldstart - 1
	local line = fn.getline(v.foldstart + 1)
	local indent = line:match("^%s*")
	line = line:match("^%s*(.-)%s*$")
	local window_width = tonumber(fn.winwidth(0)) - tonumber(api.nvim_eval('&number')) * tonumber(api.nvim_eval('&numberwidth')) - tonumber(api.nvim_eval('&foldcolumn'))
	local l = indent .. '+ ' .. line
	local r = '' .. fold_size .. '+     '
	local txt_len = window_width - (l .. r):len() + 1
	return l .. (' '):rep(txt_len) .. r
end
StatusLine({
	'%#CursorLine#',
	'%L ',
	{
		'BufEnter, BufWritePost',
		function()
			local name = fn.expand('%:t')
			if name ~= '' then
				return '‹‹ ' .. name .. ' ›› '
			end
		end
	},
	'%#LineNr#',
	{
		'User UndoRedo, BufEnter, BufLeave, FocusLost, FocusGained, BufWritePost',
		function()
			return ' ' .. V.getundotime()
		end
	},
	{
		'User UndoRedo, BufEnter, BufWritePost',
		function()
			local name = fn.expand('%:t')
			if name ~= '' then
				return [[%{&modified?'':',, saved '}]]
			end
		end
	},
	'%#Search#',
	{
		'BufEnter',
		function()
			return [[%{&readonly?'  readonly ':''}]]
		end
	},
	'%#LineNr#',
	'%=%<',
	{
		'BufEnter, BufWritePost',
		function()
			return fn.expand('%:p:~:h') .. ' '
		end
	},
	'%#CursorLine# ',
	{
		'InsertEnter, InsertLeave',
		function()
			if G.previous_layout == 'ru' then
				return 'ru '
			end
		end
	},
	'%2p%% '
})
V.map.n('<leader>1', function()
	return print('a')
end)
V.au({
	'InsertEnter',
	'InsertLeave',
	'BufLeave',
	'FocusLost'
}, '*', 'set nocul')
V.au({
	'BufEnter',
	'FocusGained'
}, '*', function()
	if V.mode() ~= 'i' then
		return V.exec('set cul')
	end
end)
V.au('TextYankPost', '*', function()
	return vim.highlight.on_yank({
		higroup = "Search",
		timeout = 100
	})
end)
V.au('BufWritePost', '~/.config/nvim/lua/*.mp', function()
	local out = V.capture('!moonp %')
	if V.eval('v:shell_error') == 1 then
		return print(out)
	end
end)
V.au('InsertLeave', '*', function()
	G.previous_layout = os.capture([[ setxkbmap -query | awk '/layout/ { print $2 }' ]])
	if G.previous_layout == 'ru' then
		return os.execute([[ setxkbmap us -variant colemak ]])
	end
end)
V.au('InsertEnter', '*', function()
	if G.previous_layout == 'ru' then
		return os.execute([[ setxkbmap ru ]])
	end
end)
return V.au('Filetype', 'help', function()
	return V.exec('wincmd L')
end)
