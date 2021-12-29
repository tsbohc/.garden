local M = { }

local vlua = require('lib.bind').vlua

local generator = { }

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
          a = table.concat(make(generator.a, winid, bufnr), ' '),
          i = table.concat(make(generator.i, winid, bufnr), ' '),
        }
        rawset(_win_table, bufnr, buf_table)
        return buf_table
      end
    })
    rawset(_cache, winid, win_table)
    return win_table
  end
})

au_cache = {}

function M.au(fn, opts, winid, bufnr)
  local id = #au_cache
  local vl = vlua(function()
    print('au')
    au_cache[id] = fn()
  end)
  vim.cmd(string.format('autocmd Eventline %s * :call %s', table.concat(opts.events, ','), vl))
  return function() return au_cache[id] end
end

function M.redraw(s)
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  cache[winid][bufnr] = nil -- this makes the line below get new data
  vim.api.nvim_win_set_option(winid, 'statusline', cache[winid][bufnr][s])
end

function M.setup()
  vim.o.laststatus = 2

  vim.cmd [[
   augroup Eventline
     au!
  ]]


  local function gen()
    return {
      a = {
        'A',
        function(winid, bufnr)
          return 'hellow from buf ' .. bufnr .. '!'
        end,
        M.au(function(winid, bufnr)
          return 'last insert on ' .. os.time()
        end, { events = { 'InsertEnter' } }),
        '|'
      },
      i = {
        'I'
      }
    }
  end

  -- we load modules here because we want M.au to generate autocmds *before* the
  -- render ones are triggered
  generator = gen()

  vim.cmd [[
     autocmd BufWinEnter,WinEnter,InsertEnter * :lua require'lib.sl'.redraw('a')
     autocmd BufWinLeave,WinLeave * :lua require'lib.sl'.redraw('i')
   augroup END
  ]]
end

return M
