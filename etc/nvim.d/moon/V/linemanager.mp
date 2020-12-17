global __statusline = {}
__events = {}
__id = 0
__modules = {}

M = {}

-- {{{
parse_opts = (...) ->
  opts = {...}

  local events, options, hook

  hook = opts[#opts+1-1]
  opts[#opts+1-1] = nil

  options = opts[#opts+1-1]
  if type(options) != 'table'
    options = nil
  else
    opts[#opts+1-1] = nil

  if #opts > 0
    events = opts

  return events, options, hook
-- }}}

-- {{{
cache = (id, val) ->
  bufnr = vim.fn.bufnr!

  if not __statusline[bufnr]
    __statusline[bufnr] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }

  data = __statusline[bufnr]

  if val
    data[id] = val
  else
    data[id] = ''
-- }}}

-- {{{
style = (output, options) ->
  -- ml, mr, pl, pr
  --print '-', output, '-'
  if options
    if output and output != ''
      output = ' '\rep(options[3]) .. output
      output = output .. ' '\rep(options[4])

      if options.hl
        output = '%#' .. options.hl .. '#' .. output .. '%#' .. M.hlreset .. '#'

      output = ' '\rep(options[1]) .. output
      output = output .. ' '\rep(options[2])
    else
      output = ''
      --output = ' '\rep(options[1]) .. output
      --output = output .. ' '\rep(options[2])

    return output

  else
    if not output
      output = ''
    return output
-- }}}

M.hlreset = 'LineNr'

M.add = (...) ->
  events, options, hook = parse_opts(...)
  __id += 1
  id = __id -- we do no want to ref global val

  if events
    for _, e in ipairs events
      __events[e] = true
    events['BufReadPost'] = true

  if type(hook) == 'string'
    output = style hook, options
    cache id, output
  elseif type(hook) == 'function'
    if events
      A.au events, '*', ->
        output = hook!
        --print 'a', hook
        output = style output, options
        cache id, output
    else
      print 'sl: no events given'


M.init = () ->
  __events['BufReadPost'] = true -- initial draw
  events = {}
  for e, _ in pairs __events
    table.insert(events, e)

  A.au events, '*', ->
    M.redraw!


M.redraw = ->
  bufnr = vim.fn.bufnr!
  data = __statusline[bufnr]

  if not data
    vim.wo.statusline = 'no data for ' .. bufnr
    return

  output = '%#' .. M.hlreset .. '#'
  for _, o in ipairs data
    output ..= o

  vim.wo.statusline = output

return M
