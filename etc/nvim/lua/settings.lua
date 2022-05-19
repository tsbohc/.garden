local se = vim.opt

vim.cmd [[set nocompatible]]

-- rendering
se.encoding = 'utf-8'
se.synmaxcol = 256
se.termguicolors = true

vim.cmd 'colo slate'

-- ui --
se.shortmess = se.shortmess + 'IcT'
se.cursorline = true

-- ruler
se.number = true
se.relativenumber = true
se.numberwidth = 2
se.signcolumn = 'yes'

-- status
se.laststatus = 2
se.showmode = false

-- tabs
se.showtabline = 2

-- match
--se.showmatch = true
--se.matchtime = 2

-- behaviour --
se.updatetime = 200
se.scrolloff = 10
se.wrap = false
se.virtualedit = 'block'
se.undofile = true
se.autoread = true
se.clipboard = 'unnamedplus'
se.mouse = 'a'
se.completeopt = { 'menu', 'menuone', 'noselect' }
--se.smartindent = true

-- formatoptions are being overwritten by ftpplugin, also h: fo-table
se.textwidth = 80
vim.cmd [[
  augroup override_formatoptions
    au!
    au VimEnter * setlocal formatoptions-=r formatoptions-=o formatoptions-=t laststatus=3
  augroup END
]]

vim.cmd [[
  augroup writing_mode
    autocmd!
    au Filetype tex,markdown set wrap
  augroup END
]]

-- splits
se.splitbelow = true
se.splitright = true

-- search
se.incsearch = true
se.inccommand = 'nosplit'
se.hlsearch = true
se.ignorecase = true
se.smartcase = true

-- folds
se.foldenable = true
se.foldmethod = 'marker'
--se.foldtext

-- {{{
  -- an indented line
-- }}}
-- TODO foldtext ^^^^

-- whitespace
se.tabstop = 2
se.shiftwidth = 2
se.softtabstop = 2
se.expandtab = true

-- conceal
se.listchars = { trail = '␣' }
se.list = true

vim.cmd [[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup = 'placeHolder', timeout = 100 }
  augroup END
]]

-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
