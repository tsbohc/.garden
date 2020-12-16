require('lib/IndexAsMethod')
local debug = false
local log
log = function(...)
	if debug then
		return print('settings -', ...)
	end
end
local s = IndexAsMethod(function(index, value)
	local get_type
	get_type = function(index)
		if pcall(function()
			return vim.api.nvim_get_option(index)
		end) then
			return 'o'
		elseif pcall(function()
			return vim.api.nvim_win_get_option(0, index)
		end) then
			return 'wo'
		elseif pcall(function()
			return vim.api.nvim_buf_get_option(0, index)
		end) then
			return 'bo'
		else
			return 'none'
		end
	end
	local t = get_type(index)
	if t == 'none' then
		if index:sub(1, 2) == 'no' then
			index = index:sub(3)
			t = get_type(index)
			log('set:', t, index, '=', false)
			vim[t][index] = false
			return
		else
			print('option not found', t, index)
			return
		end
	end
	if value then
		log('set:', t, index, '=', value)
		vim[t][index] = value
	else
		log('set:', t, index, '=', true)
		vim[t][index] = true
	end
end)
s.encoding('utf-8')
s.nocompatible()
s.synmaxcol(256)
s.termguicolors()
s.number()
s.relativenumber()
s.cursorline()
s.showmatch()
s.matchtime(2)
s.scrolloff(10)
s.nowrap()
s.virtualedit('block')
s.undofile()
s.clipboard('unnamedplus')
s.mouse('a')
s.listchars('trail:␣')
s.list()
s.incsearch()
s.inccommand('nosplit')
s.hlsearch()
s.ignorecase()
s.smartcase()
vim.cmd([[set tabstop=2]])
vim.cmd([[set shiftwidth=2]])
vim.cmd([[set softtabstop=2]])
vim.cmd([[set expandtab]])
vim.cmd([[set noshiftround]])
s.noshowmode()
s.laststatus(2)
return s.foldtext('v:lua.folding()')
