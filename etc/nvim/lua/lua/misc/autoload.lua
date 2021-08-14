local M = {}
M.autoload = function(name)
  local store = {content = false}
  local function ensure()
    if store.content then
      return store.content
    else
      local m = require(name)
      store["content"] = m
      return m
    end
  end
  local function _0_(t, ...)
    return ensure()(...)
  end
  local function _1_(t, k)
    return ensure()[k]
  end
  local function _2_(t, k, v)
    ensure()[k] = v
    return nil
  end
  return setmetatable(store, {__call = _0_, __index = _1_, __newindex = _2_})
end
local function _0_(_, ...)
  return M.autoload(...)
end
setmetatable(M, {__call = _0_})
return M