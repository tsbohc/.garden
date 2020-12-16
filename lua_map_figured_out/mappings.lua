require('lib/IndexAsMethod')
local Expr = 'expr'
local Remap = 'remap'
__mappings = { }
local map = IndexAsMethod(function(index, ...)
	local opts = {
		...
	}
	local meaning = opts[#opts + 1 - 1]
	opts[#opts + 1 - 1] = nil
	local key = opts[#opts + 1 - 1]
	opts[#opts + 1 - 1] = nil
	if type(opts[1]) == 'table' then
		opts = opts[1]
	end
	local _options = {
		noremap = true
	}
	if #opts > 0 then
		for _, o in ipairs(opts) do
			if o == 'remap' then
				_options['noremap'] = false
			else
				_options[o] = true
			end
		end
	end
	local action
	if type(meaning) == 'function' then
		local id = 'map' .. #__mappings + 1
		__mappings[id] = meaning
		action = 'v:lua.__mappings.' .. id .. '()'
	elseif type(meaning) == 'string' then
		action = meaning
	else
		print('map: invalid meaning')
	end
	for mode in index:gmatch('.') do
		vim.api.nvim_set_keymap(mode, key, action, _options)
	end
end)
vim.g.mapleader = ' '
map.nv('<ScrollWheelUp>', '<c-y>')
map.nv('<ScrollWheelDown>', '<c-e>')
map.n('<c-h>', '<c-w>h')
map.n('<c-n>', '<c-w>j')
map.n('<c-e>', '<c-w>k')
map.n('<c-i>', '<c-w>l')
map.n('Y', 'y$')
map.n('<leader>r', ':%s///g<left><left>')
map.x('<leader>r', ':s///g<left><left>')
return
