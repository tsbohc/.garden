--[[
TODO:

  shallow clone in au!!!!!!!!!!!!!

  check for duplicate modules

  have a global dict where data lives, instead of vim.b

  check line first and only activate needed modules

  au: check if function exists and reference it

--]]

_ = ' '

m = setmetatable({}, {
  __index: (k) =>
    return k
})

class StatusLine
  new: =>
    @line = {}
    @actions = {}
    @events = {}
    @modules = {}

  ine: (l) =>
    @line = l

  add: (id, events, action) =>
    @modules[id] = e: events, a: action

  --is_loaded: (m) =>

  process: (id, events, action) =>
    @actions[id] = action

    -- get info before we pop it in V.au
    @keep_events(events)

    V.au events, '*', ->
      res = @actions[id]!
      if res
        vim.b[id] = res
      else
        vim.b[id] = ''

  keep_events: (events) =>
    if type(events) == 'string'
      @events[events] = true

    elseif type(events) == 'table'
      for _, k in ipairs events
        @events[k] = true

  set: =>
    for id, m in pairs @modules
      @process id, m.e, m.a

    _e = {}
    for k, v in pairs @events
      table.insert(_e, k)

    -- redraw line itself
    V.au _e, '*', ->
      res = ''
      for _, k in pairs @line
        if type(k) == 'string' and @actions[k]
          if vim.b[k]
            res ..= vim.b[k]
        else
          res ..= k
      vim.wo.statusline = res


global L = StatusLine


L\add 'CursorMoved',
  -> return vim.fn.localtime!
L\add '%='
L\add 'arstarst'

StatusLine {
  --'CursorMoved, AnotherEvent': ->
  --   return vim.fn.localtime!
  --'string'
  'stringy'
}


---- usage
--h1 = '%#CursorLine#'
--h2 = '%#LineNr#'
--h3 = '%#Search#'
--
--statusline = {
--  h1
--  m.lines
--  _
--  m.fname
--  _
--  h2
--  _
--  m.undotime
--  m.saved
--  _
--  h3
--  m.readonly
--  h2
--  _
--
--  '%=%<'
--
--  m.cwd
--  _
--  h1
--  _
--  m.layout
--  m.percentage
--  _
--  h2
--}
--
--modules = {
--'test':
--  e: 'CursorMoved'
--  f: -> return vim.fn.localtime!
--
--'fname':
--  e: { 'BufEnter', 'BufWritePost' }
--  f: ->
--    name = fn.expand('%:t')
--    if name != ''
--      return '‹‹ ' .. name .. ' ››'
--
--'ft':
--  e: { 'BufEnter', 'BufWritePost' }
--  f: -> vim.bo.filetype
--
--'cwd':
--  e: { 'BufEnter', 'BufWritePost' }
--  f: -> fn.expand('%:p:~:h') --.. '/'
--
--'saved':
--  e: { 'User UndoRedo', 'BufEnter', 'BufWritePost' }
--  f: ->
--    name = fn.expand('%:t')
--    if name != ''
--      return [[%{&modified?'':',, saved'}]]
--
--'layout':
--  e: { 'InsertEnter', 'InsertLeave' }
--  f: ->
--    if G.previous_layout == 'ru'
--      return 'ru '
--
--'undotime':
--  e: { 'User UndoRedo', 'BufEnter', 'BufLeave', 'FocusLost', 'FocusGained', 'BufWritePost'  }
--  f: V.getundotime
--
--'readonly':
--  e: 'BufEnter'
--  f: -> [[%{&readonly?' readonly ':''}]]
--
--'lines': '%L'
--'percentage': '%2p%%'
--}
--
--StatusLine statusline, modules
