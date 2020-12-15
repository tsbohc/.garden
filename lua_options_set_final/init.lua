g = vim.g
require('utils')
P = require('M')
require('settings')
vim.cmd([[filetype on]])
P.add('neoclide/coc.nvim')
P.add('SirVer/ultisnips', function()
	g.UltiSnipsExpandTrigger = '<s-tab>'
	g.UltiSnipsJumpForwardTrigger = '<c-b>'
	g.UltiSnipsJumpBackwardTrigger = '<c-z>'
end)
P.add('honza/vim-snippets')
P.add('svermeulen/vimpeccable')
P.add('pigpigyyy/moonplus-vim')
P.add('habamax/vim-godot')
P.add('Yggdroot/indentline', function()
	g.indentLine_char = '│'
	return V.au('FileType', 'txt', function()
		return vim.cmd([[IndentLinesDisable]])
	end)
end)
P.add('dbmrq/vim-ditto')
P.add('ron89/thesaurus_query.vim')
P.add('reedes/vim-lexical')
P.add('lervag/vimtex', function()
	g.tex_flavor = 'latex'
	g.tex_conceal = ''
	g.vimtex_latexmk_continuous = 1
	g.vimtex_view_method = 'zathura'
	g.vimtex_quickfix_latexlog = {
		['default'] = 0
	}
end)
P.add('junegunn/fzf.vim')
P.add('morhetz/gruvbox', function()
	g.gruvbox_contrast_dark = 'hard'
	g.gruvbox_italicize_comments = 1
	g.gruvbox_bold = 0
end)
P.add('adigitoleo/vim-mellow')
P.add('sainnhe/sonokai')
return P.add('ayu-theme/ayu-vim')
