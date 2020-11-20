--[[
TODO:

  check for duplicate modules

  have a global dict where data lives, instead of vim.b

  check line first and only activate needed modules

  au: check if function exists and reference it

--]]

m = setmetatable({}, {
  __index: (k) =>
    return k
})

class StatusLine
  new: (line, definitions) =>
    @modules = {}
    @events = {}
    @line = line

    --for _, id in pairs line
    --  if definitions[id]
    --    m = definitions[id]
    for id, m in pairs definitions
      if true
        @add id, m

    _e = {}
    for k, v in pairs @events
      table.insert(_e, k)

    --for k, v in pairs _e
    --  print k, v

    V.au _e, '*', ->
      @redraw!

  add: (id, m) =>
    if type(m) == 'string'
      @modules[id] = true
      vim.b[id] = m

    elseif type(m) == 'table'
      @modules[id] = m.f

      -- get info before we pop it in V.au
      if type(m.e) == 'string'
        if not @events[m.e]
          @events[m.e] = true
      elseif type(m.e) == 'table'
        for _, k in ipairs m.e
          --print '  ', k
          if not @events[k]
            @events[k] = true

      V.au m.e, '*', ->
        res = @modules[id]!
        if res
          vim.b[id] = res
        else
          vim.b[id] = ''

  redraw: =>
    -- check if modules are empty
    res = ''
    for _, k in pairs @line
      if type(k) == 'string' and @modules[k]
        if vim.b[k]
          res ..= vim.b[k]
      else
        res ..= k
    vim.wo.statusline = res

_ = ' '

-- usage
h1 = '%#CursorLine#'
h2 = '%#LineNr#'
h3 = '%#Search#'

statusline = {
  h1
  m.lines
  _
  m.fname
  _
  h2
  _
  m.undotime
  m.saved
  _
  h3
  m.readonly
  h2
  _

  '%=%<'

  m.cwd
  _
  h1
  _
  m.layout
  m.percentage
  _
  h2
}

modules = {
'test':
  e: 'CursorMoved'
  f: -> return vim.fn.localtime!

'fname':
  e: { 'BufEnter', 'BufWritePost' }
  f: ->
    name = fn.expand('%:t')
    if name != ''
      return '‹‹ ' .. name .. ' ››'

'ft':
  e: { 'BufEnter', 'BufWritePost' }
  f: -> vim.bo.filetype

'cwd':
  e: { 'BufEnter', 'BufWritePost' }
  f: -> fn.expand('%:p:~:h') --.. '/'

'saved':
  e: { 'User UndoRedo', 'BufEnter', 'BufWritePost' }
  f: ->
    name = fn.expand('%:t')
    if name != ''
      return [[%{&modified?'':',, saved'}]]

'layout':
  e: { 'InsertEnter', 'InsertLeave' }
  f: ->
    if G.previous_layout == 'ru'
      return 'ru '

'undotime':
  e: { 'User UndoRedo', 'BufEnter', 'BufLeave', 'FocusLost', 'FocusGained', 'BufWritePost'  }
  f: V.getundotime

'readonly':
  e: 'BufEnter'
  f: -> [[%{&readonly?' readonly ':''}]]

'lines': '%L'
'percentage': '%2p%%'
}

StatusLine statusline, modules
