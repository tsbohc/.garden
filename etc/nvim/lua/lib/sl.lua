local vlua = require('lib.bind').vlua

local M = { }

local modules = { a = {}, i = {} }
local hl_reset = ''

local function format(s, f)
  if not s then return end
  local out = s
  if f[2] then out = string.rep(' ', f[2]) .. out end
  if f[3] then out = out .. string.rep(' ', f[3]) end
  if f.hl then
    out = '%#' .. f.hl .. '#' .. out .. '%#' .. hl_reset .. '#'
  end
  if f[1] then out = string.rep(' ', f[1]) .. out end
  if f[4] then out = out .. string.rep(' ', f[4]) end
  return out
end

local function get(m, winid, bufnr)
  if type(m) == 'function' then
    return m(winid, bufnr)
  elseif type(m) == 'table' then
    if m.format then
      return format(get(m[1], winid, bufnr), m.format)
    else
      return get(m[1], winid, bufnr)
    end
  else
    return m
  end
end

local cache = setmetatable({ }, {
  __index = function(_cache, winid)
    local win_table = setmetatable({ }, {
      __index = function(_win_table, bufnr)
        local buf_table = setmetatable({ }, {
          __index = function(_buf_table, s)
            local sl = { }

            for i, m in ipairs(modules[s]) do
              sl[i] = get(m, winid, bufnr)
            end

            --table.insert(sl, 1, '{debug ' .. winid .. ':' .. bufnr .. ' ' .. os.time() .. '}')
            sl = table.concat(sl, '')

            rawset(_buf_table, s, sl)
            return sl
          end
        })
        rawset(_win_table, bufnr, buf_table)
        return buf_table
      end
    })
    rawset(_cache, winid, win_table)
    return win_table
  end
})


function M.redraw(s)
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  cache[winid][bufnr] = nil
  vim.api.nvim_win_set_option(winid, 'statusline', cache[winid][bufnr][s])
end


local au_cache = { a = {}, i = {} }
local au_events = { a = {}, i = {} }

local function ready_au(s, v)
  local id = #au_cache[s] + 1
  au_cache[s][id] = ''

  local fn = v[1] -- TODO support strings

  vim.cmd(string.format(
    'autocmd Eventline %s * :call %s',
    table.concat(v.events, ','),
    vlua(function()
      au_cache[s][id] = fn(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    end)
  ))

  for _, e in ipairs(v.events) do
    au_events[s][e] = true
  end

  if v.format then
    return {
      function() return au_cache[s][id] end,
      format = v.format
    }
  else
    return function() return au_cache[s][id] end
  end
end

-- just do '{ item, format = { ... } }' and 'item'

function M.setup(config)
  vim.o.laststatus = 2

  vim.cmd [[
   augroup Eventline
     au!
  ]]

  for s, generator in pairs(config.generator) do
    for i, v in ipairs(generator) do
      if type(v) == 'table' then
        if v.events then
          table.insert(modules[s], i, ready_au(s, v))
        else
          table.insert(modules[s], i, v)
        end
      else
        table.insert(modules[s], i, v)
      end
    end
  end
  hl_reset = (config.hl_reset or 'Normal')

  local redraw_events = {
    a = { 'BufWinEnter', 'WinEnter' },
    i = { 'BufWinLeave', 'WinLeave' }
  }

  for s, events in pairs(au_events) do
    for k, _ in pairs(events) do
      table.insert(redraw_events[s], k)
    end
  end

  --print(vim.inspect(modules.a))

  redraw_events.a = table.concat(redraw_events.a, ',')
  redraw_events.i = table.concat(redraw_events.i, ',')

  vim.cmd(string.format([[ autocmd Eventline %s * :lua require'lib.sl'.redraw('a')]], redraw_events.a))
  vim.cmd(string.format([[ autocmd Eventline %s * :lua require'lib.sl'.redraw('i')]], redraw_events.i))

  vim.cmd [[augroup END]]
end

return M
