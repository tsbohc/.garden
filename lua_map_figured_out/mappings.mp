require 'lib/IndexAsMethod'

-- TODO: arrowkeys? move current line/indent?

Expr = 'expr'
Remap = 'remap'

global __mappings = {}

-- {{{
map = IndexAsMethod (index, ...) ->
  opts = {...}

  meaning = opts[#opts+1-1]
  opts[#opts+1-1] = nil
  key = opts[#opts+1-1]
  opts[#opts+1-1] = nil

  -- in case a table was passed
  if type(opts[1]) == 'table'
    opts = opts[1]

  _options = { noremap: true }
  if #opts > 0
    for _, o in ipairs opts
      if o == 'remap'
        _options['noremap'] = false
      else
        _options[o] = true

  local action
  if type(meaning) == 'function'
    id = 'map' .. #__mappings + 1
    __mappings[id] = meaning
    action = 'v:lua.__mappings.' .. id .. '()'
  elseif type(meaning) == 'string'
    action = meaning --.. '<cr>'
  else
    print 'map: invalid meaning'

  for mode in index\gmatch('.')
    vim.api.nvim_set_keymap(mode, key, action, _options)
-- }}}

vim.g.mapleader = ' '

---- opinionated navigation --
--
---- smart v-line movement
--map.n Expr, 'n', ->
--  if v.count > 0 then 'j' else 'gj'
--
--map.n Expr, 'e', ->
--  if v.count > 0 then 'k' else 'gk'
--
---- vertical
--map.nv 'N', '<c-d>'
--map.nv 'E', '<c-u>'
--
---- horizontal
--map.nvo 'H', '0'
--map.nvo 'I', '$'
map.nv '<ScrollWheelUp>', '<c-y>'
map.nv '<ScrollWheelDown>', '<c-e>'

-- split movement
map.n '<c-h>', '<c-w>h'
map.n '<c-n>', '<c-w>j'
map.n '<c-e>', '<c-w>k'
map.n '<c-i>', '<c-w>l'

-- consistency improvements --
map.n 'Y', 'y$'

-- search
map.n '<leader>r', ':%s///g<left><left>'
map.x '<leader>r', ':s///g<left><left>'

return
