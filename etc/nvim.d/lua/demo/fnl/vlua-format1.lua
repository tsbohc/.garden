local function _0_(...)
  local ZEST_ID_0_ = ("_" .. _G._zest.v["#"])
  local function _1_(...)
    return print(...)
  end
  _G._zest["v"][ZEST_ID_0_] = _1_
  _G._zest["v"]["#"] = (_G._zest.v["#"] + 1)
  return ("v:lua._zest.v." .. ZEST_ID_0_)
end
vim.api.nvim_command(string.format(":com -nargs=* Mycmd :call %s(<f-args>)", _0_(...)))
return 42