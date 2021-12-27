
--[[ wishlist
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
--]]

local M = {}

local data = {
  -- add hl here later
  active = { 'UNSET ', os.time, ' active' },
  inactive = { 'UNSET ', os.time, ' inactive' }
}

local cache = {}

-- returns a string to be set as the status line in the current window
function M.get(kind, win_nr)
  local xs = data[kind]

  -- this should just be flatten(cache[win_nr][buf_nr][kind]) -- do i really
  -- need wins here?
  local out = ''
  for _, v in ipairs(xs) do
    local t = type(v)
    if t == 'string' then
      out = out .. v
    elseif t == 'function' then
      out = out .. v()
    elseif t == 'table' then
      if v.format then
        --
      elseif v.events then
        -- create autocmd here, cache result and bind the returning function to
        -- an internal table
      end
    end
  end
  return out
end

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

-- (data, { pad = { 0 0 0 0 }, hl = 'LineNr' })
function M.format(...)
  --
end

function M.setup(config)
  -- TODO too naive
  if config.active then data.active = config.active end
  if config.inactive then data.inactive = config.inactive end

  vim.o.laststatus = 2

  vim.cmd [=[
    augroup EventLineSetup
      au!
      autocmd BufWinEnter,WinEnter * :lua vim.wo.statusline = string.format([[%%!luaeval('require("lib.sl").get("active", %s)')]], vim.api.nvim_get_current_win())
  ]=]

  vim.cmd [[augroup END]]
  vim.cmd [[doautocmd BufWinEnter]]

end

return M
