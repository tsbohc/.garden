local fs = {}
fs.read = function(path)
  local file = assert(io.open(path, "r"))
  local function close_handlers_0_(ok_0_, ...)
    file:close()
    if ok_0_ then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _0_()
    return file:read("*a")
  end
  return close_handlers_0_(xpcall(_0_, (package.loaded.fennel or debug).traceback))
end
fs.write = function(path, content)
  local file = assert(io.open(path, "w"))
  local function close_handlers_0_(ok_0_, ...)
    file:close()
    if ok_0_ then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _0_()
    return file:write(content)
  end
  return close_handlers_0_(xpcall(_0_, (package.loaded.fennel or debug).traceback))
end
fs.dirname = function(path)
  return path:match("(.*[/\\])")
end
local state = {fennel = false}
local function get_rtp()
  local r = ""
  local fnl_suffix = "/fnl/?.fnl"
  local lua_suffix = "/lua/?.lua"
  local rtp = (vim.o.runtimepath .. ",")
  for e in rtp:gmatch("(.-),") do
    local f = (e .. "/fnl")
    local l = (e .. "/lua")
    if (1 == vim.fn.isdirectory(f)) then
      r = (r .. ";" .. (e .. fnl_suffix))
    elseif (1 == vim.fn.isdirectory(l)) then
      r = (r .. ";" .. (e .. lua_suffix))
    end
  end
  return r:sub(2)
end
local function load_fennel()
  local fennel = require("neozest.fennel")
  print("<neozest> initialise compiler")
  fennel.path = (get_rtp() .. ";" .. fennel.path)
  state.fennel = fennel
  return state.fennel
end
local M = {}
M.compile = function()
  local source = vim.fn.expand("%:p")
  if not source:find("macros.fnl$") then
    local fennel = (state.fennel or load_fennel())
    local fnl_path = vim.fn.resolve((vim.fn.stdpath("config") .. "/fnl"))
    local lua_path = vim.fn.resolve((vim.fn.stdpath("config") .. "/lua"))
    local target = string.gsub(string.gsub(source, ".fnl$", ".lua"), fnl_path, lua_path)
    vim.fn.mkdir(fs.dirname(target), "p")
    return fs.write(target, fennel.compileString(fs.read(source)))
  end
end
local function _0_(_, ...)
  return M.compile(...)
end
setmetatable(M, {__call = _0_})
return M
