-- we're exporting everything
global *

api = vim.api
g = vim.g
v = vim.v
fn = vim.fn
cmd = vim.cmd

-- capture output of shell commands
os.capture = (cmd, raw) ->
  f = assert(io.popen(cmd, 'r'))
  io.input(f)
  s = assert(io.read('*a'))
  io.close(f)
  if raw then return s
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s

-- set colorscheme
colorscheme = (name) ->
  vim.cmd 'colorscheme ' .. name

-- create autocmds
-- TODO: redo when proper api
__autocmds = {}

-- reset the augroup (exists check ended up erroring)
cmd 'augroup ___autocmds'
cmd 'augroup END'
cmd 'autocmd! ___autocmds'

au = (event, pattern, cmd) ->
  if type(cmd) == 'function'
    id = #__autocmds + 1
    __autocmds[id] = cmd

    api.nvim_command 'augroup ___autocmds'

    if type(event) == 'string'
      api.nvim_command 'autocmd ' .. event .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()'
    elseif type(event) == 'table'
      for _, e in ipairs event
        api.nvim_command 'autocmd ' .. e .. ' ' .. pattern .. ' lua __autocmds[' .. id .. ']()'

    api.nvim_command 'augroup END'

  elseif type(cmd) == 'string'

    api.nvim_command 'augroup ___autocmds'

    if type(event) == 'string'
      api.nvim_command 'autocmd ' .. event .. ' ' .. pattern .. ' ' .. cmd
    elseif type(event) == 'table'
      for _, e in ipairs event
        api.nvim_command 'autocmd ' .. e .. ' ' .. pattern .. ' ' .. cmd

    api.nvim_command 'augroup END'
