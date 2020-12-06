g = vim.g
V = require('V')
M = require('M')
M.ice('neoclide/coc.nvim')
M.ice('SirVer/ultisnips', function()
	g.UltiSnipsExpandTrigger = '<s-tab>'
	g.UltiSnipsJumpForwardTrigger = '<c-b>'
	g.UltiSnipsJumpBackwardTrigger = '<c-z>'
end)
M.ice('honza/vim-snippets')
M.ice('svermeulen/vimpeccable')
M.ice('pigpigyyy/moonplus-vim')
M.ice('habamax/vim-godot')
M.ice('Yggdroot/indentline', function()
	g.indentLine_char = '│'
end)
M.ice('dbmrq/vim-ditto')
M.ice('ron89/thesaurus_query.vim')
M.ice('reedes/vim-lexical')
M.ice('lervag/vimtex', function()
	g.tex_flavor = 'latex'
	g.tex_conceal = ''
	g.vimtex_latexmk_continuous = 1
	g.vimtex_view_method = 'zathura'
	g.vimtex_quickfix_latexlog = {
		['default'] = 0
	}
end)
M.ice('junegunn/fzf.vim')
M.ice('morhetz/gruvbox', function()
	g.gruvbox_contrast_dark = 'hard'
	g.gruvbox_italicize_comments = 1
	g.gruvbox_bold = 0
end)
M.ice('adigitoleo/vim-mellow')
M.ice('sainnhe/sonokai')
return M.ice('ayu-theme/ayu-vim')
