
-- vim.b.status.arst = foo DOESN'T WORK! https://github.com/neovim/neovim/issues/12544


--[[ TODO:
-- {{{
set bufinfo per buffer, cache it
update only when relevant event sends a signal?
or send a table to redrawstatusline({ 'saved' }), etc
the events will prolly spiral out of control, but seems like a good idea
this way not everything will be reevaluated on CursorMoved, etc

smth like

S.module { 'CursorMoved', 'ICursorMoved' }, 'variablename', ->
  return percentage

to produce

modules = {
  'variablename': function
}

au CursorMoved * :lua vim.b.status[ .. variablename .. ] = modules[ .. variablename .. ]

vim.b.status = {
  'variablename': 'foo'
}

module should keep track of all passed events and update statusline on all of them
!! easy to do with new au wrapper

the info will be grabbed from cache an updated on individual basis for each module
-- }}}

scrollbar?
--]]

-- update statusline
-- TODO: create those artificially from modules' events later
V.au { 'BufEnter', 'BufLeave', 'BufWritePost', 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'InsertLeave' }, '*', ->
  V.redrawstatus!

b = vim.b

G.home = os.getenv('HOME')

global __modules = {}

global S = {
  mod: (event, name, command) ->
    if __modules[name]
      print 'S.mod: module with the name \'' .. name .. '\' already exists!'
      print 'skipping...'
      return

    __modules[name] = command

    -- having pattern in user aus breaks them
    -- FIXME!!
    if type(event) == 'string'
      if event\match('User ')
        V.au event, '', ->
          b[name] = __modules[name]!
      else
        V.au event, '*', ->
          b[name] = __modules[name]!
    else
      V.au event, '*', ->
        b[name] = __modules[name]!
}

S.mod 'User UndoRedo', 'undotime', ->
  return V.getundotime!

S.mod 'BufEnter', 'readonly', ->
  return [[%{&readonly?' readonly ':''}]]

S.mod 'BufEnter,BufWritePost', 'filetype', ->
  return vim.bo.filetype

S.mod 'BufEnter,BufWritePost', 'cwd', ->
  b.info = vim.fn.getbufinfo()[b.bufnr]
  if b.info.name == ''
    path = os.capture('pwd')
    return path\gsub(G.home, '~') .. '/'
  else
    return b.info.name\gsub(G.home, '~')\match('(.*[/\\])')

S.mod 'BufEnter,BufWritePost', 'filename', ->
  b.info = vim.fn.getbufinfo()[b.bufnr]
  if b.info.name == ''
    return ''
  else
    name = string.match(b.info.name, "^.+/(.+)$")
    return '‹‹ ' .. name .. ' ››'

S.mod 'User UndoRedo,BufEnter,BufWritePost', 'saved', ->
  b.info = vim.fn.getbufinfo()[b.bufnr]
  if b.info.name != ''
    return [[%{&modified?'':',, saved'}]]

-- pretty sure it's haunted
-- well, that's because G.previous_layout doesn't update until InsertLeave
S.mod { 'InsertEnter', 'InsertLeave', 'TextChangedI', 'CursorMoved' }, 'layout', ->
  --return os.capture [[ setxkbmap -query | awk '/layout/ { print $2 }' ]]
  if not G.previous_layout
    return 'us'
  else
    return G.previous_layout

-- format data before returning
out = (data) ->
  _out = ''
  for _, k in pairs data
    _out ..= k
  return _out

_ = ' '

global statusline = (bufnr) ->
  b.bufnr = bufnr

  --if vim.bo.filetype == 'help'
  --  return '%#CursorLine#' .. ' help ' .. '%#LineNr#' .. '%=' .. '%#CursorLine#' .. ' %p%% '

  out {
    '%#CursorLine#'
    '%L'
    _
    b.filename
    _
    '%#LineNr#'
    _
    b.undotime
    b.saved
    _
    '%#Search#'
    b.readonly
    '%#LineNr#'
    _
    '%='
    '%<'
    b.cwd
    _

    '%#CursorLine#'
    _
    b.layout
    _
    '%2p%%'
    _
    '%#LineNr#'
  }


--[[
-- {{{
  padding = ->
    size = tonumber(api.nvim_eval '&number') * tonumber(api.nvim_eval '&numberwidth') + tonumber(api.nvim_eval '&foldcolumn') - 1
    return string.rep(' ', size)


  -- this is bad because some bufinfo is already in bufinfo
  percent = ->
    blocks = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
    current_line = vim.fn.line('.')
    total_line = vim.fn.line('$')
    if current_line == 1 then
      return blocks[1]
    elseif current_line == vim.fn.line('$') then
      return blocks[#blocks]
    d = current_line / total_line
    index = vim.fn.float2nr(d * #blocks)
    if index == 0
      index = 1
    block = blocks[index]
    return block

  mode = ->
    modes = {
      'n': 'normal'
      'i': '.. %f ..'
      'v': '-- %f --'
      'V': '== %f =='
      'c': '›› %f ‹‹'
      'B': 'vib'
    }

    m = V.mode!
    txt = modes[m]

    if txt == nil
      return m
    else
      return txt
-- }}}
--]]
