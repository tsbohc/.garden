__id = 0

global __autocmds = {}
cmd = vim.api.nvim_command

flatten = (t) ->
  n = #t
  res = ''
  for i, v in ipairs t
    res ..= v
    if i < n
      res ..= ','
  return res

M = (...) ->
  -- TODO: assert checks for nils, hook types
  local events, ft, hook
  opts = {...}

  hook = opts[#opts+1-1]
  opts[#opts+1-1] = nil
  ft = opts[#opts+1-1]
  opts[#opts+1-1] = nil

  if #opts == 0
    print 'au: no events given'
    return
  elseif #opts == 1 and type(opts[1]) == 'table'
    events = opts[1]
  else
    events = opts

  __id += 1
  id = 'au' .. __id

  flat_events = flatten events
  --print flat_events

  cmd 'augroup ' .. id
  cmd 'autocmd!'
  if type(hook) == 'function'
    __autocmds[id] = hook
    cmd 'au ' .. flat_events .. ' ' .. ft .. ' ' .. ':lua __autocmds.' .. id .. '()'
  else
    cmd 'au ' .. flat_events .. ' ' .. ft .. ' ' .. hook
  cmd 'augroup end'

  --print id
  --print 'au ' .. flat_events .. ' ' .. ft .. ' ' .. ':lua __autocmds.' .. id .. '()'


return M
