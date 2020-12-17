require 'lib/IndexAsMethod'

global __mappings = {}

return IndexAsMethod (index, ...) ->
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

    -- get id
    local id = 1
    for _ in pairs __mappings
      id += 1
    id = 'map' .. id

    -- store function
    __mappings[id] = meaning

    -- bind it
    if _options['expr'] == true
      action = 'v:lua.__mappings.' .. id .. '()'
    else
      -- suppress :lua __mappings.map1() output
      _options['silent'] = true
      -- no clue why the above doesn't work for non-exprs
      action = ':lua __mappings.' .. id .. '()<cr>'

  elseif type(meaning) == 'string'
    action = meaning
  else
    print 'map: invalid meaning'

  for mode in index\gmatch('.')
    vim.api.nvim_set_keymap(mode, key, action, _options)
