_G.sl = {}
local hl_reset = "LineNr"
local draw_events_set = {BufEnter = true, VimEnter = true}
local counter = 0
local function format(s, options)
  local o = (s or "")
  if (options and (o ~= "")) then
    o = ((" "):rep(options[3]) .. o)
    o = (o .. (" "):rep(options[4]))
    if options[5] then
      o = ("%#" .. options[5] .. "#" .. o .. "%#" .. hl_reset .. "#")
    end
    o = ((" "):rep(options[1]) .. o)
    o = (o .. (" "):rep(options[2]))
  end
  return o
end
local function store(s, id)
  local bufnr = vim.fn.bufnr()
  if not _G.sl[bufnr] then
    _G.sl[bufnr] = {}
    for i = 1, 25 do
      _G.sl[bufnr][i] = ""
    end
  end
  _G.sl[bufnr][id] = (s or "")
  return nil
end
local M = {}
M.fn = function(events, opts, f)
  counter = (counter + 1)
  for _, k in ipairs(events) do
    draw_events_set[k] = true
  end
  local id = counter
  local t
  local function _0_()
    return store(format(f(), opts), id)
  end
  t = _0_
  local _1_
  do
    local ZEST_N_0_ = _G._zest.v["#"]
    local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
    _G._zest["v"][ZEST_ID_0_] = t
    _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
    _1_ = ("v:lua._zest.v." .. ZEST_ID_0_)
  end
  return vim.api.nvim_command(("au " .. table.concat(events, ",") .. " * :call " .. _1_ .. "()"))
end
M.st = function(opts, s)
  counter = (counter + 1)
  local id = counter
  return store(format(s, opts), id)
end
local function draw()
  local bufnr = vim.fn.bufnr()
  vim.wo.statusline = ("%#" .. hl_reset .. "#" .. table.concat(_G.sl[bufnr]))
  return nil
end
M.init = function()
  local draw_events = {}
  for k, _ in pairs(draw_events_set) do
    table.insert(draw_events, k)
  end
  draw_events = table.concat(draw_events, ",")
  local cmd = vim.api.nvim_command
  cmd("augroup event-statusline")
  cmd("au!")
  local _0_
  do
    local ZEST_N_0_ = _G._zest.v["#"]
    local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
    _G._zest["v"][ZEST_ID_0_] = draw
    _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
    _0_ = ("v:lua._zest.v." .. ZEST_ID_0_)
  end
  cmd(("au " .. draw_events .. " * :call " .. _0_ .. "()"))
  return cmd("augroup END")
end
return M