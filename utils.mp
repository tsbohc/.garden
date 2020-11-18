require('vimp')

-- we're exporting everything
global *

api = vim.api
g = vim.g
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
    vim.wo.statusline = statusline(vim.fn.bufnr())
}

__autocmds = {}

V.exec 'augroup ___autocmds'
V.exec 'augroup END'
V.exec 'autocmd! ___autocmds'

-- {{{
V.au = (event, pattern, command) ->
  if type(command) != 'string' and type(command) != 'function'
    return

  V.exec 'augroup ___autocmds'

  if type(command) == 'function'
    id = #__autocmds + 1
    __autocmds[id] = command

    if type(event) == 'string'
      V.exec 'autocmd ' .. event .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()'
    elseif type(event) == 'table'
      for _, e in ipairs event
        V.exec 'autocmd ' .. e .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()'

  elseif type(command) == 'string'

    if type(event) == 'string'
      V.exec 'autocmd ' .. event .. ' ' .. pattern .. ' ' .. command
    elseif type(event) == 'table'
      for _, e in ipairs event
        V.exec 'autocmd ' .. e .. ' ' .. pattern .. ' ' .. command

  V.exec 'augroup END'
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
-- {{{
V.getundotime = (action) ->
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

  plural = ''
  d = vim.fn.localtime! - get_undo_time(undotree.seq_cur)
  w = false

  if undotree.seq_cur == undotree.seq_last
    return 'now'
    --d = vim.fn.localtime! - get_undo_time(undotree.save_last)

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

-- set initial
G.undotime = V.getundotime!

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

