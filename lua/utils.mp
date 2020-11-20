require('vimp')

-- this aparently works
-- autocmd  BufReadPost,FileReadPost   *.pl,*.pm   :silent %!perltidy -q

-- we're exporting everything
global *



uuu = 'unset'

api = vim.api
g = vim.g
b = vim.b
v = vim.v
fn = vim.fn
cmd = vim.cmd

G = {}

V = {
  exec: (command) ->
    vim.api.nvim_command command

  norm: (command) ->
    vim.api.nvim_command 'norm! ' .. command

  capture: (command) ->
    return vim.api.nvim_exec command, true

  eval: (string) ->
    vim.api.nvim_eval string

  mode: ->
    vim.fn.mode!

  -- add check if file exists or try expect
  colorscheme: (name) ->
    vim.api.nvim_command 'colorscheme ' .. name

  redrawstatus: ->
    vim.wo.statusline = statusline()
}

__autocmds = {}

V.exec 'augroup ___autocmds'
V.exec 'augroup END'
V.exec 'autocmd! ___autocmds'

-- {{{
-- TODO: user events check, multiple events in one line
flatten = (t) ->
  n = #t
  res = ''
  for i, v in ipairs t
    res ..= v
    if i < n
      res ..= ','
  return res

check_for_user_events = (e) ->
  if type(e) == 'string'
    if e\match('User ')
      return true
  elseif type(e) == 'table'
    for _, k in pairs e
      if k\match('User ')
        return true
  return false

V.au = (events, pattern, action) ->
  if type(action) != 'string' and type(action) != 'function'
    return

  debug = false

  if type(action) == 'function'
    id = #__autocmds + 1
    __autocmds[id] = action

    action = ':lua __autocmds[' .. id .. ']()'

  V.exec 'augroup ___autocmds'

  if check_for_user_events(events)
    if type(events) == 'string'
      pattern = ''
    elseif type(events) == 'table'
      for i, k in pairs events
        if k\match('User ')
          V.exec 'autocmd ' .. k .. ' ' .. action
          if debug
            print 'autocmd ' .. k .. ' ' .. action
          table.remove(events, i)

  if type(events) == 'table'
    -- in case it was a table with one User au
    if #events == 0
      return
    events = flatten(events)

  V.exec 'autocmd ' .. events .. ' ' .. pattern .. ' ' .. action
  if debug
    print 'autocmd ' .. events .. ' ' .. pattern .. ' ' .. action

  V.exec 'augroup END'
  if debug
    print ' '
-- }}}

-- i am too dumb to wrap exprs myself
V.map = setmetatable({
  n: (...) ->
    vimp.bind 'n', ...
  v: (...) ->
    vimp.bind 'v', ...
  s: (...) ->
    vimp.bind 's', ...
  x: (...) ->
    vimp.bind 'x', ...
  o: (...) ->
    vimp.bind 'o', ...
  i: (...) ->
    vimp.bind 'i', ...
  c: (...) ->
    vimp.bind 'c', ...
}, {
  __call: (...) =>
    vimp.bind ...
})

-- relative undo time
-- TODO
-- what if i stored absolute time and added time passed since to it
-- while updating the vim.b value every n seconds or so? depending on delta size
-- {{{
V.getundotime = () ->
  -- {{{
  time = {
    second: 1
    minute: 60
    hour: 60 * 60
    day: 24 * 60 * 60
    week: 7 * 24 * 60 * 60
    month: 30.5 * 24 * 60 * 60
    year: 365 * 24 * 60 * 60
  }
  -- }}}

  undotree = vim.fn.undotree()

  get_undo_time = (seq) ->
    idx = seq
    for _, entry in pairs undotree.entries
      if entry.seq == idx
        return entry.time
    return vim.fn.localtime()

  d = 0
  fname = vim.fn.expand('%:p')

  -- pretty bad but works TODO

  if undotree.seq_cur == undotree.seq_last and fname != ''
    -- get last modified time if were at the latest point in history 
    -- without any more recent changes
    d1 = vim.fn.localtime! - tonumber(os.capture('stat -c %Y ' .. fname))
    d2 = vim.fn.localtime! - get_undo_time(undotree.seq_cur)
    if d1 < d2
      d = d2
    else
      d = d1
  elseif fname == ''
    return 'unsaved'
  else
    d = vim.fn.localtime! - get_undo_time(undotree.seq_cur)

  plural = ''
  w = false

  if d <= time.second
    return 'moments ago'
  elseif d < time.minute
    return d .. ' seconds ago'
  elseif d < time.hour
    w = 'minute'
  elseif d < time.day
    w = 'hour'
  elseif d < time.week
    w = 'day'
  elseif d < time.month
    w = 'week'
  elseif d < time.year
    w = 'month'
  else
    return 'more than a year ago'

  if w
    n = math.floor(d / time[w])
    if n > 1 then plural = 's' else plural = ''
    return n .. ' ' .. w .. plural .. ' ago'

  --lplural = ''
  --lines_before = vim.fn.line('$')
  --V.exec ':silent ' .. action
  --lines_after = vim.fn.line('$')

  --d_lines = lines_after - lines_before
  --if math.abs(d_lines) > 1 lplural = 's' else lplural = ''

  --if d_lines > 0
  --  --d_lines = ', ' .. d_lines .. ' line' .. lplural .. ' more'
  --  d_lines = ', +' .. d_lines .. ' line' .. lplural
  --elseif d_lines < 0
  --  --d_lines = ', ' .. math.abs(d_lines) .. ' line' .. lplural .. ' less'
  --  d_lines = ', ' .. d_lines .. ' line' .. lplural
  --else
  --  d_lines = 'now'
-- }}}

-- capture output of shell commands
-- {{{
os.capture = (command, raw) ->
  f = assert(io.popen(command, 'r'))
  io.input(f)
  s = assert(io.read('*a'))
  io.close(f)
  if raw then return s
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
-- }}}

--[[
-- {{{
__mapcmds = {}

execmap = (id) ->
  replace_special_chars = (str) ->
    return vim.api.nvim_replace_termcodes(str, true, false, true)

  __mapcmds[id]!
  --return replace_special_chars(result)

V._map = (...) ->
  local modes, options, sequence, meaning

  _options = { noremap: true }

  if #{...} == 3
    modes, sequence, meaning = ...
  elseif #{...} == 4
    modes, options, sequence, meaning = ...

  if options != nil
    for _, k in ipairs options
      if k == 'remap'
        _options['noremap'] = false
      else
        _options[k] = true

  for mode in modes\gmatch '.'
    if type(meaning) == 'string'
      vim.api.nvim_set_keymap mode, sequence, meaning, _options
    elseif type(meaning) == 'function'
      id = #__mapcmds + 1
      __mapcmds[id] = meaning

      vim.api.nvim_set_keymap mode, sequence, 'v:lua.execmap('..id..')<cr>', _options
-- }}}
--]]

