--        .
--  __   __)
-- (. | /o ______  __  _.
--    |/<_/ / / <_/ (_(__
--    |
--

-- {{{
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
         --U = '<c-r>',
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

   --rescue()
   -- }}}

-- au.my_group(function()
--   au.cmd({'BufLeave', 'BufEnter'}, '*', function()
--     print("hello")
--   end)
-- end)

require('settings')
require('paq')
require('keymaps')

local sl = require('lib.sl')

local function generator()
   local xs = { }
   local f = sl.format

   local function add(data)
      table.insert(xs, data)
   end

   add(sl.helper.au(
   function()
      local file = vim.fn.expand('%:t')
      if file == '' then
         file = '‹ new ›'
      end
      return f(file, 'CursorLine', { 0, 1, 1, 1 })
   end, { 'BufEnter', 'BufWritePost' }
   ))

   add(sl.helper.au(function()
      if vim.fn.expand('%:t') ~= '' then
         return f("%{&modified?'':'saved'}", { 0, 0, 0, 1 })
      end
   end, { 'BufEnter', 'BufWritePost' }))

   add(sl.helper.au(
   function()
      if vim.bo.readonly then return end
      local format = { 0, 0, 0, 0 }
      if vim.fn.expand('%:t') == '' then return f('unsaved', format) end

      local save_time = vim.fn.getftime(vim.fn.expand('%:p'))
      local curr_time = vim.fn.localtime()

      if save_time == -1 then
         return f('unsaved', format)
      elseif save_time == curr_time then
         return f('moments ago', format)
      end

      local undotree = vim.fn.undotree()
      local undo_time

      for _, entry in ipairs(undotree.entries) do
         if entry.seq == undotree.seq_cur then
            undo_time = entry.time
            break
         end
      end

      print((undotree.seq_cur == undotree.seq_last and 'same' or 'diff'))
      print(os.date('%B %d, %y at %H:%M', curr_time))
      print(os.date('%B %d, %y at %H:%M', save_time))
      print(os.date('%B %d, %y at %H:%M', undo_time))
      print('---')

      local d
      if undotree.seq_cur == undotree.seq_last then
         d = save_time - curr_time
      elseif undo_time then
         d = curr_time - undo_time
      else
         d = 'origin'
      end

      local suffix

      -- TODO
      local hl_group = 'LineNr'

      if type(d) ~= 'string' and d < 0 then
         d = -d
      else
         hl_group = 'Search'
      end

      if type(d) == 'string' then
         --
      elseif d == 0 then
         d = 'now'
      elseif d < 60 then
         suffix = 'second'
      elseif d < 3600 then
         d = math.floor(d / 60)
         suffix = 'minute'
      elseif d < 86400 then
         d = math.floor(d / 3600)
         suffix = 'hour'
      elseif d < 604800 then
         d = math.floor(d / 86400)
         suffix = 'day'
      else
         d = os.date('%B %d, %y at %H:%M', save_time)
      end

      if suffix then
         d = d .. ' ' .. suffix .. (d > 1 and 's' or '') .. ' ago'
      end

      return f(d, hl_group, format)
   end, { 'BufEnter', 'BufWritePost', 'CursorMoved' }
   ))

   add(sl.helper.au(
   function()
      if vim.bo.readonly then
         return f('readonly', 'Search', { 1, 1, 1, 0 })
      end
   end, { 'BufEnter' }
   ))

   -- last time in insert in a buffer
   --add(sl.helper.au(function(w, b)
   --  return f(os.time() .. ' in buf #' .. b, 'Error')
   --end, { 'InsertEnter' }))

   add('%=%<')

   add(sl.helper.au(
   function()
      return f(vim.fn.expand('%:p:~:h') .. '/', { 1, 0, 0, 0 })
   end, { 'BufEnter', 'BufWritePost' }
   ))

   add(sl.helper.au(
   function()
      local out = ''
      for _, kind in ipairs({ 'Warning', 'Error' }) do
         local n = vim.lsp.diagnostic.get_count(0, kind)
         if n > 0 then
            out = out .. '‹'.. f(n, 'DiagnosticSign' .. kind) .. '›'
         end
      end
      return f(out, { 1, 0, 0, 0 })
   end, { 'VimEnter', 'CursorMoved', 'CursorMovedI' }
   ))

   add(sl.helper.au(
   function()
      return f(vim.bo.filetype, { 1, 0, 0, 0 })
   end, { 'BufEnter', 'BufReadPost', 'BufWritePost' }
   ))

   add(f('%2p%%', 'CursorLine', { 1, 1, 1, 0 }))

   return xs
end

sl.setup {
   hl_reset = 'LineNr',
   generator = generator,
}







   --local b = require('lib.bind')
   --print(vim.inspect(b))


   -- function W.Keyring(callback)
      --   -- get a fresh table with callable keys,
      --   -- the key is passed as the first argument to the callback
      --   return setmetatable({}, {
         --     __index = function(self, key)
            --       self[key] = function(...)
               --         callback(key, ...)
               --       end
               --       return rawget(self, key)
               --     end
               --   })
               -- end
