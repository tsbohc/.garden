local vlua = require('lib.bind').vlua

local M = { }

-- TODO:
-- clear invalid windows

-- general vim stuff: i want to be able to switch between splits in insert mode

M.helper = { }
M.format = { }

function M.format(s, ...)
   if s == '' or nil then return '' end

   local out = s
   local hl_group
   local fm_table

   for _, a in ipairs({...}) do
      if type(a) == 'string' then
         hl_group = a
      elseif type(a) == 'table' then
         fm_table = a
      end
   end

   if fm_table then
      out = string.rep(' ', fm_table[2]) .. out .. string.rep(' ', fm_table[3])
   end
   if hl_group then
      out = '%#' .. hl_group .. '#' .. out .. '%#' .. M.hl_reset .. '#'
   end
   if fm_table then
      out = string.rep(' ', fm_table[1]) .. out .. string.rep(' ', fm_table[4])
   end

   return out
end

local function resolve(m, winid, bufnr)
   if type(m) == 'string' then
      return true, m
   elseif type(m) == 'function' then
      return pcall(m, winid, bufnr)
   else
      return false
   end
end

local cache = setmetatable({ }, {
   __index = function(_cache, winid)
      local win_table = setmetatable({ }, {
         __index = function(_win_table, bufnr)
            local sl = { }

            for i, m in ipairs(M.generator) do
               local ok, data = resolve(m, winid, bufnr)
               if not ok or data == nil then
                  sl[i] = ''
               else
                  sl[i] = data
               end
            end

            sl = table.concat(sl, '')

            rawset(_win_table, bufnr, sl)
            return sl
         end
      })

      rawset(_cache, winid, win_table)
      return win_table
   end
})

M.au = {
   cache = { },
   events = { },
   counter = 0
}

function M.helper.au(fn, events)
   M.au.counter = M.au.counter + 1
   local id = M.au.counter

   local vlua_ref = vlua(function()
      local winid = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_get_current_buf()
      if not M.au.cache[winid] then M.au.cache[winid] = { } end
      if not M.au.cache[winid][bufnr] then M.au.cache[winid][bufnr] = { } end
      M.au.cache[winid][bufnr][id] = fn(winid, bufnr)
   end)

   for _, e in ipairs(events) do
      M.au.events[e] = true
      vim.cmd(string.format('autocmd Eventline %s * :call %s', e, vlua_ref))
   end

   return function(winid, bufnr)
      return M.au.cache[winid][bufnr][id]
   end
end

function M.redraw()
   local winid = vim.api.nvim_get_current_win()
   local bufnr = vim.api.nvim_get_current_buf()
   cache[winid][bufnr] = nil
   vim.api.nvim_win_set_option(winid, 'statusline',
      '%#' .. M.hl_reset .. '#' .. cache[winid][bufnr])
   -- print(vim.opt.statusline._value)
end

function M.setup(config)
   vim.o.laststatus = 2
   M.hl_reset  = config.hl_reset or 'Normal'

   vim.cmd [[
      augroup Eventline
      au!
   ]]

   M.generator = config.generator() or { 'no generator specified' }

   for e, _ in pairs(M.au.events) do
      vim.cmd(string.format([[autocmd Eventline %s * :lua require'lib.sl'.redraw()]], e))
   end

   vim.cmd [[
      autocmd Eventline WinEnter * :lua require'lib.sl'.redraw()
      autocmd Eventline BufWinEnter * :lua require'lib.sl'.redraw()
   augroup END
   ]]
end

return M
