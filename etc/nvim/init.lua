--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

require('plugins')
require('settings')
require('keymaps')

-- snippet ++
-- 	${1:x} = $1 + ${2:1}
-- snippet --
-- 	${1:x} = $1 - ${2:1}
-- snippet **
-- 	${1:x} = $1 * ${2:1}
-- snippet //
-- 	${1:x} = $1 / ${2:1}

-- local function copy(args)
--   return args[1]
-- end

-- ls.add_snippets('lua', {
--   s('l', {
--     t 'local ', i(1, 'x'), t ' = ' , i(0, '42')
--   }),
--   s('fn', {
--     t 'local function ',
--     i(1, 'f'),
--     t '(',
--     i(2, '...'),
--     t ')',
--     t {'', '\t'}, t({
--       t 'print(',
--       f(copy, 2),
--       t ')'
--     }),
--     t {'', 'end'}
--   }),
-- })

-- ls.add_snippets('lua', {
--   s('l', fmt([[
--     local {} = {}
--   ]], {
--     i(1, 'x'),
--     i(2, '0')
--   })),
--   s('fn', fmt([[
--     local function {fn_name}({fn_args})
--       {fn_final}
--     end
--   ]], {
--     fn_name = i(1, 'f'),
--     fn_args = i(2, '...'),
--     fn_final = f(function(args)
--       return 'print(' .. args[1][1] .. ')'
--     end, 2)
--   })),
-- })


-- maybe an autocmd can decide if i'm editing the config and switch the mode?

-- local fnl_runtime = vim.fn.stdpath('config') .. '/fnl'
-- vim.o.runtimepath = vim.o.runtimepath .. ',' .. fnl_runtime

-- local fennel = require("fennel")
-- fennel.path = fennel.path .. ";" .. fnl_runtime .. "/?.fnl"
-- fennel.path = fennel.path .. ";" .. fnl_runtime .. "/?/init.fnl"
-- fennel['macro-path'] = fennel['macro-path'] .. ";" .. fnl_runtime .. "/?.fnl"
-- fennel['macro-path'] = fennel['macro-path'] .. ";" .. fnl_runtime .. "/?/init.fnl"
--
-- table.insert(package.loaders or package.searchers, fennel.searcher)
--
-- local test = require('test')




--
-- -- luarocks convention
-- vim.cmd [[autocmd FileType lua :set shiftwidth=3 tabstop=3]]
--
-- statusline TODO: rip into a separate file
local sl = require('lib.sl')

local function generator()
   local xs = { }
   local f = sl.format

   local function add(data)
      table.insert(xs, data)
   end

   add(sl.helper.au(function()
      local file = vim.fn.expand('%:t')
      if vim.w.quickfix_title then
         file = '‹ quickfix ›'
      elseif file == '' then
         file = '‹ new ›'
      end
      return f(file, 'CursorLine', { 0, 1, 1, 1 })
   end, { 'BufEnter', 'BufWritePost' }))

   add(sl.helper.au(function()
      if vim.bo.readonly then return end
      local format = { 0, 0, 0, 0 }
      if vim.fn.expand('%:t') == '' then return f('unsaved', format) end

      local save_time = vim.fn.getftime(vim.fn.expand('%:p'))
      local curr_time = vim.fn.localtime()

      if save_time == -1 then
         return f('unsaved', format)
      elseif save_time == curr_time then
         return f('◆', format)
      end

      local undotree = vim.fn.undotree()
      local undo_time

      for _, entry in ipairs(undotree.entries) do
         if entry.seq == undotree.seq_cur then
            undo_time = entry.time
            break
         end
      end

      local delta = 0

      local icon = ''
      icon = icon .. 'curr ' .. os.date('%H:%M:%S', curr_time) .. ' | '
      icon = icon .. 'save ' .. os.date('%H:%M:%S', save_time) .. ' | '
      icon = icon .. 'undo ' .. os.date('%H:%M:%S', undo_time) .. ' |'

      if undotree.seq_cur == undotree.seq_last then
         if undo_time then
            delta = undo_time - save_time
            icon = '△'
         else
            return f('◆', format)
         end
      elseif undo_time then
         delta = undo_time - save_time
         if undo_time > save_time then
            icon = '▽'
         else
            icon = '▼'
         end
      else
         delta = '-inf.'
      end

      local hl_group = 'LineNr'

      local function format_number(n)
         local suffix
         local d = math.abs(n)

         if d < 60 then
            suffix = 's'
         elseif d < 3600 then
            d = math.floor(d / 60)
            suffix = 'm'
         elseif d < 86400 then
            d = math.floor(d / 3600)
            suffix = 'h'
         elseif d < 604800 then
            d = math.floor(d / 86400)
            suffix = 'd'
         else
            d = os.date('%B %d, %y at %H:%M', save_time)
         end

         if n == 0 then
            --
         elseif n > 0 then
            d = '+' .. d
         else
            d = '-' .. d
         end

         if suffix then
            d = icon .. ' ' .. d .. suffix
         end

         return d
      end

      if type(delta) == 'number' then
         delta = format_number(delta)
      end

      return f(delta, hl_group, format)
   end, { 'BufEnter', 'BufWritePost', 'TextChanged', 'TextChangedI' }))

   add(sl.helper.au(function()
      if vim.bo.readonly then
         return f('readonly', 'Search', { 1, 1, 1, 0 })
      end
   end, { 'BufEnter' }))

   add('%=%<')

   add(sl.helper.au(function()
      return f(vim.fn.expand('%:p:~:h') .. '/', { 1, 0, 0, 0 })
   end, { 'BufEnter', 'BufWritePost' }))

   -- add(sl.helper.au(function()
   --    local out = ''
   --    for _, kind in ipairs({ 'Warning', 'Error' }) do
   --       local n = vim.lsp.diagnostic.get_count(0, kind)
   --       if n > 0 then
   --          out = out .. '‹'.. f(n, 'DiagnosticSign' .. kind) .. '›'
   --       end
   --    end
   --    return f(out, { 1, 0, 0, 0 })
   -- end, { 'VimEnter', 'CursorMoved', 'CursorMovedI' }))

   add(sl.helper.au(function()
      return f(vim.bo.filetype, { 1, 0, 0, 0 })
   end, { 'BufEnter', 'BufReadPost', 'BufWritePost' }))

   add(f('%2p%%', 'CursorLine', { 1, 1, 1, 0 }))

   return xs
end

sl.setup {
   hl_reset = 'LineNr',
   generator = generator,
}


-- NOTE do not remove
-- -- {{{
-- local function rescue()
--    local keys = {
--       n = 'j',
--       e = 'k',
--       I = '$',
--       H = '0',
--       N = '<c-d>',
--       E = '<c-u>',
--       ['<c-h>'] = '<c-w>h',
--       ['<c-n>'] = '<c-w>j',
--       ['<c-e>'] = '<c-w>k',
--       ['<c-i>'] = '<c-w>l',
--       ['//'] = ':nohlsearch<cr>',
--       --U = '<c-r>',
--       ['<c-j>'] = 'J',
--       i = 'l',
--       l = 'i',
--       L = 'I',
--       f = 'e',
--       F = 'E',
--       j = 'f',
--       J = 'F',
--       k = 'n',
--       K = 'N',
--    }
--    for k, v in pairs(keys) do
--       vim.api.nvim_set_keymap('n', k, v, { noremap = true })
--       vim.api.nvim_set_keymap('v', k, v, { noremap = true })
--       vim.api.nvim_set_keymap('o', k, v, { noremap = true })
--    end
-- end
-- --rescue()
-- -- }}}

-- -- function W.Keyring(callback)
-- --   -- get a fresh table with callable keys,
-- --   -- the key is passed as the first argument to the callback
-- --   return setmetatable({}, {
-- --     __index = function(self, key)
-- --       self[key] = function(...)
-- --         callback(key, ...)
-- --       end
-- --       return rawget(self, key)
-- --     end
-- --   })
-- -- end
