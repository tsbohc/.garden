local function _0_(...)
  local ZEST_N_0_ = _G._zest.v["#"]
  local ZEST_ID_0_ = ("_" .. ZEST_N_0_)
  local function _1_(...)
    return print(...)
  end
  _G._zest["v"][ZEST_ID_0_] = _1_
  _G._zest["v"]["#"] = (ZEST_N_0_ + 1)
  return ("v:lua._zest.v." .. ZEST_ID_0_)
end
vim.cmd(string.format(":com -nargs=* Mycmd :call %s(<f-args>)", _0_(...)))
return 42