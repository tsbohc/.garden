local set = require('IndexAsMethod')(function(index, value)
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
			vim[t][index] = false
			return
		else
			print('option not found', t, index)
			return
		end
	end
	if value then
		vim[t][index] = value
	else
		vim[t][index] = true
	end
end)
set.encoding('utf-8')
set.nocompatible()
set.synmaxcol(256)
set.termguicolors()
set.number()
set.relativenumber()
set.cursorline()
set.showmatch()
set.matchtime(2)
set.scrolloff(10)
set.wrap()
set.virtualedit('block')
set.undofile()
set.clipboard('unnamedplus')
set.mouse('a')
set.listchars('trail:␣')
set.list()
set.incsearch()
set.inccommand('nosplit')
set.hlsearch()
set.ignorecase()
set.smartcase()
set.tabstop(2)
set.shiftwidth(2)
set.softtabstop(2)
set.expandtab()
set.noshiftround()
set.noshowmode()
set.laststatus(2)
return set.foldtext('v:lua.folding()')
