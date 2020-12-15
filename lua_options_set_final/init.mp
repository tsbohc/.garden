--[[      .
'  __   __)
' (. | /o ______  __  _.
'    |/<_/ / / <_/ (_(__
'    |
'                     ]]--

-- INIT!!!!!!!!!!!!!!!!!!!!!!!!1

--[[
TODO:
- check if paq exists and pull from git if needed
--]]

-- globals: separate?
global g = vim.g
--global V = require 'V'
require 'utils'
global P = require 'M'

require 'settings'

--------------------------------
--          plugins           --
--------------------------------

-- code --
--P.add { 'neoclide/coc.nvim', opt: true, branch: 'release' }

-- !!!!!
-- add ~/.local/share/nvim/site/pack/ice/opt/*/lua
-- to path or something??

vim.cmd [[filetype on]]

--vim.cmd [[autocmd FileType python echo "woo"]]

P.add 'neoclide/coc.nvim'

P.add 'SirVer/ultisnips', ->
  g.UltiSnipsExpandTrigger = '<s-tab>'
  g.UltiSnipsJumpForwardTrigger = '<c-b>'
  g.UltiSnipsJumpBackwardTrigger = '<c-z>'

P.add 'honza/vim-snippets'

-- FIXME: runtime path problems with opt packages
P.add 'svermeulen/vimpeccable'

P.add 'pigpigyyy/moonplus-vim'
P.add 'habamax/vim-godot'

--V.au 'FileType', 'python', ->
P.add 'Yggdroot/indentline', ->
  -- FIXME
  -- set a ft for typeless docs
  -- reeval ft when saving if needed
  g.indentLine_char = '│'
  V.au 'FileType', 'txt', ->
    vim.cmd [[IndentLinesDisable]]
  --V.au { 'BufNewFile', 'BufRead' }, '*',
  --  if vim.bo.filetype == ''
  --    g.indentLine_char = ''

-- write --
P.add 'dbmrq/vim-ditto'
P.add 'ron89/thesaurus_query.vim'
P.add 'reedes/vim-lexical'

-- latex --
P.add 'lervag/vimtex', ->
  g.tex_flavor = 'latex'
  g.tex_conceal = ''
  g.vimtex_latexmk_continuous = 1
  g.vimtex_view_method = 'zathura'
  g.vimtex_quickfix_latexlog = { 'default': 0 }

-- general --
P.add 'junegunn/fzf.vim'

-- style --
P.add 'morhetz/gruvbox', ->
  g.gruvbox_contrast_dark = 'hard'
  g.gruvbox_italicize_comments = 1
  --g.gruvbox_italic = 1
  g.gruvbox_bold = 0

P.add 'adigitoleo/vim-mellow'
P.add 'sainnhe/sonokai'
P.add 'ayu-theme/ayu-vim'


