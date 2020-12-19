--[[      .
'   __   __)
'  (. | /o ______  __  _.
'     |/<_/ / / <_/ (_(__
'     |
--]]

--[[ TODO

[ ] clean up dead lua files if *.mp is missing

[ ] fuzzy completion

[ ] startscreen

[ ] switch to NEST navigation, t is a dead key rn!!
    what about WM navigation though?

[ ] check if moonp -m minimified is worth it

[ ] replace system calls with vim.loop api

[ ] find a place for globals like g = vim.g

--]]

--global A = require 'V'

global V = {}

V.set         = require 'V.set'
V.map         = require 'V.map'
V.au          = require 'V.au'
V.linemanager = require 'V.linemanager'

V.exec = (command) ->
  vim.api.nvim_command command

V.norm = (command) ->
  vim.api.nvim_command 'norm! ' .. command

V.capture = (command) ->
  return vim.api.nvim_exec command, true

V.eval = (string) ->
  vim.api.nvim_eval string

V.fn = vim.fn

--V.mode = ->

-- add check if file exists or try expect
V.colorscheme = (name) ->
  vim.api.nvim_command 'colorscheme ' .. name

V.definecmd = (name, action) ->
  -- maybe even take name as IndexAsMethod
  print name, action

-- V.fs = TODO isfile/isdir with vim.loop

--dofile '/home/sean/.config/nvim/lua/plugins.lua'

require 'startscreen'
require 'plugins'
require 'settings'
require 'mappings'
require 'statusline'
require 'autocmds'

global folding = () ->
  fold_size = v.foldend - v.foldstart - 1

  --line = fn.getline v.foldstart
  --if string.len(line) <= 6

  line = fn.getline v.foldstart + 1
  indent = line\match("^%s*")
  line = line\match("^%s*(.-)%s*$")

  window_width = tonumber(fn.winwidth(0)) - tonumber(api.nvim_eval '&number') * tonumber(api.nvim_eval '&numberwidth') - tonumber(api.nvim_eval '&foldcolumn')

  l = indent .. '+ ' .. line
  r= '' .. fold_size .. '+     '

  txt_len = window_width - (l .. r)\len! + 1

  return l .. ' '\rep(txt_len) .. r

