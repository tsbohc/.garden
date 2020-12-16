--[[      .
'   __   __)
'  (. | /o ______  __  _.
'     |/<_/ / / <_/ (_(__
'     |
--]]

--[[ TODO

[ ] separate *.mp and compiled *.lua directories
    clean up dead lua files if *.mp is missing
    write moonstronaut for this

[ ] treesitter and lsp and fuzzy completion

[ ] switch to NEST navigation, t is a dead key rn!!
    what about WM navigation though?

[ ] modularize V
    V = {}
    V.test = require 'V/test'

    and keep config split for easier debugging

[ ] check if moonp -m minimified is worth it

[ ] replace system calls with vim.loop api

[ ] find a place for globals like g = vim.g

--]]

-- TODO get rid of this
require 'utils'

dofile '/home/sean/.config/nvim/lua/plugins.lua'
require 'settings'
require 'mappings'
--require 'autocmds' TODO

