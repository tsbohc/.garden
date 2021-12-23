--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

local function rescue()
  local keys = {
    n = 'j',
    e = 'k',
    I = '$',
    H = '0',
    N = '<c-d>',
    E = '<c-u>',

    ['<c-h>'] = '<c-w>h',
    ['<c-n>'] = '<c-w>j',
    ['<c-e>'] = '<c-w>k',
    ['<c-i>'] = '<c-w>l',

    ['//'] = ':nohlsearch<cr>',

    U = '<c-r>',
    ['<c-j>'] = 'J',

    i = 'l',

    l = 'i',
    L = 'I',

    f = 'e',
    F = 'E',

    j = 'f',
    J = 'F',

    k = 'n',
    K = 'N',
  }

  for k, v in pairs(keys) do
    vim.api.nvim_set_keymap('n', k, v, { noremap = true })
    vim.api.nvim_set_keymap('v', k, v, { noremap = true })
    vim.api.nvim_set_keymap('o', k, v, { noremap = true })
  end
end
rescue() -- make this a :Cmd that requires a file

require('settings')
--require('keymaps')
require('packs')



-- {{{
-- i want a loader that would prefer .lua files over .fnl files if (IF!) they're newer
-- and i want .lua files to be regenerated and compiled to bytecode with :FennelCompile

--local function loader(name)
--  local basename = name:gsub('%.', '/')
--  local fnl_paths = {
--    basename .. ".fnl",
--    basename .. "/init.fnl"
--  }
--  local lua_paths = {
--    basename .. ".lua",
--    basename .. "/init.lua"
--  }
--
--  -- just code musing
--  for i, fnl_path in ipairs(fnl_paths) do
--    local fnl_found = vim.api.nvim_get_runtime_file(fnl_path, false)
--    if #fnl_found > 0 then
--      local lua_found = vim.api.nvim_get_runtime_file(lua_paths[i], false)
--      if #lua_found > 0 then
--        if vim.fn.getftime(lua_found[1]) > vim.fn.getftime(fnl_found[1]) then
--          return function() return dofile(lua_found[1]) end
--        else
--          fennel = require('fennel')
--          return function() return fennel.dofile(fnl_found[1]) end
--        end
--      else
--        fennel = require('fennel')
--        return function() return fennel.dofile(fnl_found[1]) end
--      end
--    else
--      local lua_found = vim.api.nvim_get_runtime_file(lua_paths[i], false)
--      if #lua_found > 0 then
--        return function() return dofile(lua_found[1]) end
--      end
--    end
--  end
--
--  return nil
--end
--
--table.insert(package.loaders or package.searchers, loader)
--- }}}}
