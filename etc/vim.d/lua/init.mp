--[[      .
'  __   __)
' (. | /o ______  __  _.
'    |/<_/ / / <_/ (_(__
'    |
'                     ]]--

--[[
TODO:
- check if paq exists and pull from git if needed
--]]

-- globals: separate?
global g = vim.g
global V = require 'V'
global M = require 'M'

--------------------------------
--          plugins           --
--------------------------------

-- code --
--M.ice { 'neoclide/coc.nvim', opt: true, branch: 'release' }

-- !!!!!
-- add ~/.local/share/nvim/site/pack/ice/opt/*/lua
-- to path or something??

M.ice 'neoclide/coc.nvim'

M.ice 'SirVer/ultisnips', ->
  g.UltiSnipsExpandTrigger = '<s-tab>'
  g.UltiSnipsJumpForwardTrigger = '<c-b>'
  g.UltiSnipsJumpBackwardTrigger = '<c-z>'

M.ice 'honza/vim-snippets'

-- FIXME: runtime path problems with opt packages
M.ice 'svermeulen/vimpeccable'

M.ice 'pigpigyyy/moonplus-vim'
M.ice 'habamax/vim-godot'

M.ice 'Yggdroot/indentline', ->
  g.indentLine_char = '│' -- set elsewhere ???
  -- maybe check how variable was changing?

-- write --
M.ice 'dbmrq/vim-ditto'
M.ice 'ron89/thesaurus_query.vim'
M.ice 'reedes/vim-lexical'

-- latex --
M.ice 'lervag/vimtex', ->
  g.tex_flavor = 'latex'
  g.tex_conceal = ''
  g.vimtex_latexmk_continuous = 1
  g.vimtex_view_method = 'zathura'
  g.vimtex_quickfix_latexlog = { 'default': 0 }

-- general --
M.ice 'junegunn/fzf.vim'

-- style --
M.ice 'morhetz/gruvbox', ->
  g.gruvbox_contrast_dark = 'hard'
  g.gruvbox_italicize_comments = 1
  --g.gruvbox_italic = 1
  g.gruvbox_bold = 0

M.ice 'adigitoleo/vim-mellow'
M.ice 'sainnhe/sonokai'
M.ice 'ayu-theme/ayu-vim'
