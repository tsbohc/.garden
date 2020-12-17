--[[      .
'   __   __)
'  (. | /o ______  __  _.
'     |/<_/ / / <_/ (_(__
'     |
--]]

--[[ TODO

[x] separate *.mp and compiled *.lua directories
[ ] clean up dead lua files if *.mp is missing

[ ] treesitter and lsp and fuzzy completion

[ ] startscreen

[ ] switch to NEST navigation, t is a dead key rn!!
    what about WM navigation though?

[x] modularize V
    V = {}
    V.test = require 'V/test'

    and keep config split for easier debugging

[ ] check if moonp -m minimified is worth it

[ ] replace system calls with vim.loop api

[ ] find a place for globals like g = vim.g

--]]

global A = require 'V'

A.exec = (command) ->
  vim.api.nvim_command command

A.norm = (command) ->
  vim.api.nvim_command 'norm! ' .. command

A.capture = (command) ->
  return vim.api.nvim_exec command, true

A.eval = (string) ->
  vim.api.nvim_eval string

-- add check if file exists or try expect
A.colorscheme = (name) ->
  vim.api.nvim_command 'colorscheme ' .. name

A.definecmd = (name, action) ->
  -- maybe even take name as IndexAsMethod
  print name, action

-- A.fs = TODO isfile/isdir with vim.loop

-- TODO get rid of this
require 'utils'

dofile '/home/sean/.config/nvim/lua/plugins.lua'

require 'settings'
require 'mappings'
require 'statusline'
--require 'autocmds' TODO
