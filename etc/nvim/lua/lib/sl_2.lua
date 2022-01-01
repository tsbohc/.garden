local vlua = require('lib.bind').vlua

-- TODO
-- would like the sl to update once a minute passively or something

local M = { }

local modules = { }
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
        local sl = { }

        for i, m in ipairs(modules) do
          sl[i] = get(m, winid, bufnr) or ''
        end

        --table.insert(sl, 1, '{debug ' .. winid .. ':' .. bufnr .. ' ' .. os.time() .. '}')
        sl = table.concat(sl, '')

        rawset(_win_table, bufnr, sl)
        return sl
      end
    })
    rawset(_cache, winid, win_table)
    return win_table
  end
})


function M.redraw()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  cache[winid][bufnr] = nil
  vim.api.nvim_win_set_option(winid, 'statusline', cache[winid][bufnr])
end


local au_cache = { }
local au_events = { }

local function ready_au(v)
  local id = #au_cache + 1
  au_cache[id] = ''

  local fn = v[1] -- TODO support strings

  vim.cmd(string.format(
    'autocmd Eventline %s * :call %s',
    table.concat(v.events, ','),
    vlua(function()
      au_cache[id] = fn(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    end)
  ))

  for _, e in ipairs(v.events) do
    au_events[e] = true
  end

  if v.format then
    return {
      function() return au_cache[id] end,
      format = v.format
    }
  else
    return function() return au_cache[id] end
  end
end

-- just do '{ item, format = { ... } }' and 'item'

function M.setup(config)
  vim.o.laststatus = 2

  vim.cmd [[
   augroup Eventline
     au!
  ]]

  for i, v in ipairs(config.generator) do
    if type(v) == 'table' then
      if v.events then
        table.insert(modules, i, ready_au(v))
      else
        table.insert(modules, i, v)
      end
    else
      table.insert(modules, i, v)
    end
  end
  hl_reset = (config.hl_reset or 'Normal')

  local redraw_events = {
    a = { 'BufWinEnter', 'WinEnter' },
    i = { 'BufWinLeave', 'WinLeave' }
  }

  for k, _ in pairs(au_events) do
    table.insert(redraw_events, k)
  end

  --print(vim.inspect(modules.a))

  redraw_events = table.concat(redraw_events, ',')
  vim.cmd(string.format([[ autocmd Eventline %s * :lua require'lib.sl'.redraw()]], redraw_events))

  vim.cmd [[augroup END]]
end

return M
