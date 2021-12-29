local M = { }
local modules = { }

local vlua = require('lib.bind').vlua

-- could get status too if i want to, i guess
local function make(items, winid, bufnr)
  local out = { }
  for i, item in ipairs(items) do
    local t = type(item)
    if t == 'string' then
      table.insert(out, i, item)
    elseif t == 'function' then
      table.insert(out, i, item(winid, bufnr))
    end
  end

  local debug = winid .. ':' .. bufnr .. ' ' .. os.time()
  table.insert(out, 1, debug)

  return out
end

local cache = setmetatable({ }, {
  __index = function(_cache, winid)
    local win_table = setmetatable({ }, {
      __index = function(_win_table, bufnr)
        local buf_table = {
          a = table.concat(make(modules.a, winid, bufnr), ' '),
          i = table.concat(make(modules.i, winid, bufnr), ' '),
        }
        rawset(_win_table, bufnr, buf_table)
        return buf_table
      end
    })
    rawset(_cache, winid, win_table)
    return win_table
  end
})

-- function M.au(fn, opts)
--   local id = #au_cache
--
--   vim.cmd(string.format(
--     'autocmd Eventline %s * :call %s',
--     table.concat(opts.events, ','),
--     vlua(function()
--       au_cache[id] = fn(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
--     end)
--   ))
--
--   for _, e in ipairs(opts.events) do
--     au_events[e] = true
--   end
--
--   return function() return au_cache[id] end
-- end

function M.redraw(s)
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  cache[winid][bufnr] = nil -- this makes the line below get new data
  vim.api.nvim_win_set_option(winid, 'statusline', cache[winid][bufnr][s])
end

local au_cache = { }
local au_events = { a = {}, i = {} }

-- we can get active/inactive here
local function ready(generator, s)
  local modules = { }
  for i, v in ipairs(generator) do
    if type(v) == 'table' then
      if v.events then

        -- extract this into a function
        local id = #au_cache
        local fn = v[1] -- just do function only for now

        vim.cmd(string.format(
          'autocmd Eventline %s * :call %s',
          table.concat(v.events, ','),
          vlua(function()
            au_cache[id] = fn(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
          end)
        ))

        -- store events separately
        for _, e in ipairs(v.events) do
          au_events[s][e] = true
        end

        table.insert(modules, i, function()
          return au_cache[id]
        end)
      end
    else
      table.insert(modules, i, v)
    end
  end
  return modules
end

function M.setup()
  vim.o.laststatus = 2

  vim.cmd [[
   augroup Eventline
     au!
  ]]

  -- make format() a helper function that can be called from anywhere?
  -- or just do '{ item, { ... } }' and 'item' for modules

  modules.a = ready({
    'A',
    {
      function(_, bufnr)
        return 'last insert on ' .. os.time() .. ' in ' .. bufnr
      end,
      events = { 'InsertEnter' }
    }
  }, 'a')

  modules.i = { 'I' }

  --

  local redraw_events = {
    a = { 'BufWinEnter', 'WinEnter' },
    i = { 'BufWinLeave', 'WinLeave' }
  }

  for s, events in pairs(au_events) do
    for k, _ in pairs(events) do
      table.insert(redraw_events[s], k)
    end
  end

  redraw_events.a = table.concat(redraw_events.a, ',')
  redraw_events.i = table.concat(redraw_events.i, ',')
  --print(vim.inspect(redraw_events))

  vim.cmd(string.format([[ autocmd %s * :lua require'lib.sl'.redraw('a')]], redraw_events.a))
  vim.cmd(string.format([[ autocmd %s * :lua require'lib.sl'.redraw('i')]], redraw_events.i))
  vim.cmd [[augroup END]]
end

return M
