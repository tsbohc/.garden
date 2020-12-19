

-- lazy load based on ft
--P.add '+text,md', 'Yggdroot/indentline', ->
--  g.indentLine_char = '│'


-- ????

P = require 'lib/PluginManager'
g = vim.g

ft = {}
ft.text = 'txt,md'

--------------------------------
--          plugins           --
--------------------------------

--P.add 'neoclide/coc.nvim'

-- lsp & treesitter
P.add 'neovim/nvim-lspconfig'
P.add 'nvim-treesitter/nvim-treesitter'

-- completion
P.add 'nvim-lua/completion-nvim'
P.add 'steelsojka/completion-buffers'

-- snippets
P.add 'SirVer/ultisnips', ->
  g.UltiSnipsExpandTrigger = '<s-tab>'
  g.UltiSnipsJumpForwardTrigger = '<c-b>'
  g.UltiSnipsJumpBackwardTrigger = '<c-z>'

P.add 'honza/vim-snippets'

-- FIXME: runtime path problems with opt packages
P.add 'svermeulen/vimpeccable'

P.add 'pigpigyyy/moonplus-vim'
P.add 'habamax/vim-godot'

-- FIXME
-- set a ft for typeless docs
-- reeval ft when saving if needed

P.add 'Yggdroot/indentline', ->
  g.indentLine_char = '│'
  V.au 'FileType', ft.text, ->
    vim.cmd [[IndentLinesDisable]]

--P.opt 'Yggdroot/indentline', ->
--  g.indentLine_char = '│'

--V.au 'FileType', ft.text, ->
--  P.lazy 'Yggdroot/indentline'

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

return
