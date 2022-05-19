-- nb :redrawstatus and :redrawstatus! commands

local vlua = require('lib.bind').vlua

local M = { }

local function format(s, f)
end

local generator = {
  'a',
  function()
    return 'b'
  end,
  format('c', { 0, 0 }),
  'd',
  {
    fn = function() return 'woo' end,
    events = { 'InsertEnter' }
  },
}

-- what tj does is flattening stuff from within cache itself and returning a
-- ready string (i think so). mine is a little more specific so i want it to
-- return a rendered element.

-- i should still go with the win_id -> buf_nr -> id structure i think, will
-- make stuff easier later

-- i need something like a self destructing element for autocmds so that it'll
-- just create an autocmd on ready and replace itself with '' while keeping
-- formatting data. maybe generator as a function is not a very good idea.

local cache = setmetatable({}, {
  __index = function(self, bufnr)
    local val = setmetatable({}, {
      __index = function(buf_table, id)
        local item = generator[id]

        local t = type(item)
        if t == 'function' then
          item = item(bufnr)
        elseif t == 'table' then
          if item.events then
            local function f()
              print(id)
              print(vim.inspect(generator))
              buf_table[id] = generator[id].fn()
            end
            vim.cmd(string.format(
              'autocmd Eventline %s * :call %s',
              table.concat(item.events, ','),
              vlua(f
              -- function()
              --   print(vim.inspect(item))
              --   buf_table[id] = item[1]()
              -- end
              )
            ))
            --generator[id] = ''
            --item = generator[id]
          end
        end

        rawset(buf_table, id, item)
        return item
      end
    })

    rawset(self, bufnr, val)
    return val
  end
})


local function ready()
  -- creat autocmds here
end

-- main

function M.statusline()
  local winid = vim.g.actual_curwin
  local bufnr = vim.g.actual_curbuf
  --local winid = vim.fn.win_getid()
  --local bufnr = vim.fn.bufnr()

  --if tonumber(winid) == vim.fn.win_getid() then
  --  return table.concat(cache[bufnr]['a'], ' ')
  --else
  --  return table.concat(cache[bufnr]['i'], ' ')
  --end

  return cache[bufnr][5]
end

local function draw()
  vim.wo.statusline = "%{%v:lua.require'lib.sl'.statusline()%}"
end

function M.setup(--[[_config]])
  --ready()
  vim.o.laststatus = 2

  vim.cmd 'augroup Eventline'
  vim.cmd 'au!'
  draw()
  vim.cmd 'augroup END'
  -- print(vim.inspect(cache.a[2]))
  -- print(vim.inspect(cache))
end

return M




-- local function update(winid, bufnr, status, id)
--   if not cache[winid] then cache[winid] = { } end
--   if not cache[winid][bufnr] then cache[winid][bufnr] = { a = { }, i = { } } end
--
--   local module = config[status][id]
--   local t = type(module)
--   if t == 'string' then
--     return module
--   elseif t == 'function' then
--     return module(winid, bufnr)
--   end
-- end
--
-- local function render(winid, bufnr, status, id)
--   return cache[winid][bufnr][status][id]
-- end
--
-- local function format(s, format)
-- end
--
-- local function ready()
-- end
--
-- -- return a slatusline string of a given status
-- -- local function render(winid, bufnr, status)
-- --   if not cache[bufnr] then cache[bufnr] = { a = { }, i = { } } end
-- --   local line_cache = cache[bufnr][status]
-- --   for id, module in ipairs(config[status]) do
-- --     -- local c = format(update(winid, bufnr, module), module.format)
-- --     -- if type(module) == 'table' and module.format then
-- --     --   c = format(c, module.format)
-- --     -- end
-- --     line_cache[id] = format(update(winid, bufnr, module), module.format)
-- --   end
-- --   return winid .. ':' .. bufnr .. ' ' .. table.concat(line_cache, ' ')
-- -- end
--
-- local function draw()
--   vim.o.statusline = "%{%v:lua.require'lib.sl'.statusline()%}"
-- end
--
-- function M.statusline()
--   local bufnr = vim.g.actual_curbuf
--   local winid = vim.g.actual_curwin
--   local l = {}
--
--   if tonumber(winid) == vim.fn.win_getid() then
--     for id = 1, #config.a do
--       cache[winid][bufnr]['a'][id] = update(winid, bufnr, 'a', id)
--       table.insert(l, render(winid, bufnr, 'a', id))
--       return table.concat(l, ' ')
--     end
--   else
--     for id = 1, #config.i do
--       cache[winid][bufnr]['i'][id] = update(winid, bufnr, 'i', id)
--       table.insert(l, render(winid, bufnr, 'i', id))
--       return table.concat(l, ' ')
--     end
--   end
-- end
--
-- local a = {}
-- a[1] = 'a'
-- a[2] = 'b'
-- a[5] = 'e'
--
-- for i, v in ipairs(a) do
--   print(i, v) -- => only prints 'a' and 'b'
-- end
-- print(table.concat(a, ' ')) -- => same thing here


--[[
initial pass (think __ready function)
config        cache
string    ->  string
function  ->  function
autocmd   ->  string ('' (to be updated))
]]--

































-- -- process a module and return a string
-- local function make(winid, bufnr, module)
--   local t = type(module)
--   if t == 'string' then
--     return module
--   elseif t == 'function' then
--     return module(winid, bufnr)
--   elseif t == 'table' then
--     local out = make(winid, bufnr, module[1])
--
--     if module.format then
--       -- format the result here
--       out = out
--     end
--     return out
--   end
-- end

-- if type(module) == 'table' then
--   if module.events then
--     vim.cmd(string.format(
--       'autocmd Eventline %s * :call %s',
--       table.concat(module['events'], ','),
--       vlua(function()
  --         local bufnr = vim.fn.bufnr()
  --         if not cache[bufnr] then cache[bufnr] = { a = { }, i = { } } end
  --         cache[bufnr][status][id] = module[1]()
  --       end)
  --     ))
  --     config[status][id] = 'au'
  --   end
  -- end
-- config = _config

-- local _config = {
  --   a = {
    --     'a',
    --     function(_, _) return os.time() end, -- winnr and bufnr are here
    --     {
      --       function(_, _)
        --         return '[' .. os.time() .. ']'
        --       end,
        --       events = { 'InsertEnter' }
        --     }
        --   },
        --   i = {
          --     'i',
          --     function(_, _) return os.time() end,
          --   }
          -- }
          -- config = _config
          --
          -- vim.cmd 'augroup Eventline'
          -- vim.cmd 'au!'
          -- vim.cmd 'augroup END'
          --
          -- print(vim.inspect(config))


-- check all buffer data on BufDelete (runs after BufUnload, so the buffer should no
-- be loaded at this point) and clean up old stuff
-- (with vim.api.nvim_buf_is_loaded())






--[[ wishlist {{{
if only only one buf is loaded, hide tabline
if tabline is hidden (one buf is loaded), show filename in the statusline

-- the os.time() runs only for the active buffer when it is interacted with
-- (also entering/exiting :cmd updates it)
-- so basically event caching is something that's actually nice to have

nesting metatables so that

data[buf_nr][item_nr] would actually go through two calls and generate stuff if needed? idk

{ function()
    -- do some cool stuff and return a string
  end, events = { 'CursorMoved' }
}


maybe i should instead leverage normal autocmds

au({ 'CursorMoved' }, '*', function()
  cache[... -- how do i pass buf_nr?
end)


i think i should do win_id and bufnr and pass them through elements, yeah
that way i get info about window.width and what not. like this:

function my_element(win, buf)
  return 'some string'
end

what is window anyway? this? vim.fn.getwininfo(win_id) ???
--]]

-- local data = {
--   -- add hl here later
--   active = { 'UNSET ', os.time, ' active' },
--   inactive = { 'UNSET ', os.time, ' inactive' }
-- }
--
-- local cache = {}
--
-- -- returns a string to be set as the status line in the current window
-- function M.get(kind, win_id)
--   local xs = data[kind]
--
--   -- this should just be flatten(cache[win_id][buf_nr][kind]) -- do i really
--   -- need wins here?
--   local out = ''
--   for _, v in ipairs(xs) do
--     local t = type(v)
--     if t == 'string' then
--       out = out .. v
--     elseif t == 'function' then
--       out = out .. v()
--     elseif t == 'table' then
--       if v.format then
--         --
--       elseif v.events then
--         -- create autocmd here, cache result and bind the returning function to
--         -- an internal table
--       end
--     end
--   end
--   return out
-- end
--
--local function cache(xs)
--  for i, v in ipairs(xs) do
--    local t = type(v)
--    if t == 'string' then
--      cache[i] = v
--    elseif t == 'function' then
--      cache[i] = v
--    elseif t == 'table' then
--      if v.format then
--        --
--      elseif v.events then
--        -- create autocmd here, cache result and bind the returning function to
--        -- an internal table
--      end
--    end
--  end
--end

-- -- (data, { pad = { 0 0 0 0 }, hl = 'LineNr' })
-- function M.format()
--   --
-- end

-- local function is_active()
--   return tonumber(vim.g.actual_curwin) == vim.fn.win_getid()
-- end


--local function parse(config)
--  local generator 
--  for kind, xs in pairs(config) do
--    for i, module in ipairs(xs) do
--      local t = type(module)
--      if t == 'table' then
--      else
--        generator[kind][i] = module
--      end
--    end
--  end
--  print(vim.inspect(generator))
--end